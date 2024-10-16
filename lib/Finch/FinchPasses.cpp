//===- FinchPasses.cpp - Finch passes -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/Rewrite/FrozenRewritePatternSet.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"

#include "Finch/FinchPasses.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir::finch {
#define GEN_PASS_DEF_FINCHSIMPLIFIER
#define GEN_PASS_DEF_FINCHINSTANTIATE
#define GEN_PASS_DEF_FINCHLOOPLETRUN
#define GEN_PASS_DEF_FINCHLOOPLETSEQUENCE
#define GEN_PASS_DEF_FINCHLOOPLETSTEPPER
#define GEN_PASS_DEF_FINCHLOOPLETPASS
#include "Finch/FinchPasses.h.inc"

namespace {
class FinchNextLevelRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(scf::ForOp forOp,
                                PatternRewriter &rewriter) const final {
    auto indVar = forOp.getInductionVar();
    
    OpBuilder builder(forOp);
    Location loc = forOp.getLoc();

    for (auto& accessOp : *forOp.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        auto accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          auto nextLevelOp = accessOp.getOperand(0).getDefiningOp<finch::NextLevelOp>();
          if (!nextLevelOp) {
            continue;
          }
          
          Value nextLevelPosition = nextLevelOp.getOperand(); 
          rewriter.replaceOp(&accessOp, nextLevelPosition);

          return success();
        }
      }
    }
    
    return failure();
  }
};

class FinchInstantiateRewriter : public OpRewritePattern<finch::GetLevelOp> {
public:
  using OpRewritePattern<finch::GetLevelOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(finch::GetLevelOp op,
                                PatternRewriter &rewriter) const final {
    Value levelDef = op.getOperand(0);
    Value levelPos = op.getOperand(1);
    
    Operation* lvlDefOp = levelDef.getDefiningOp<finch::DefineLevelOp>();
    if (!lvlDefOp) {
      return failure();
    }

    Operation* lvlPosOp = levelPos.getDefiningOp<finch::AccessOp>();
    if (lvlPosOp) {
      // position is coming from finch::AccessOp,
      // which means looplet passes are not done.
      return failure();
    }


    Block &defBlock = lvlDefOp->getRegion(0).front();
    Operation* retLooplet = defBlock.getTerminator();
    Value looplet = retLooplet->getOperand(0);
    rewriter.inlineBlockBefore(&defBlock, op, ValueRange(levelPos));
    rewriter.eraseOp(retLooplet);
    rewriter.replaceOp(op, looplet);
    //llvm::outs() << *(op->getBlock()->getParentOp()) << "\n";

    
    return success();

    //if (op.getSymName() == "bar") {
    //  rewriter.modifyOpInPlace(op, [&op]() { op.setSymName("foo"); });
    //  return success();
    //}
    //return failure();
  }
};

class FinchSemiringRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(scf::ForOp op,
                                PatternRewriter &rewriter) const final {
    for (auto& bodyOp : *op.getBody()) {
      if (isa<arith::MulFOp>(bodyOp)) {
        auto constOp = bodyOp.getOperand(1).getDefiningOp();
        if (matchPattern(constOp, m_AnyZeroFloat())) {
          rewriter.replaceOp(&bodyOp, constOp);
          return success();
        }
      } else if (isa<arith::AddFOp>(bodyOp)) {
        auto constOp = bodyOp.getOperand(1).getDefiningOp();
        if (matchPattern(constOp, m_AnyZeroFloat())) {
          rewriter.replaceOp(&bodyOp, bodyOp.getOperand(0));
          return success();
        }
      }
    }

    return failure();
  }
};



class FinchMemrefStoreLoadRewriter : public OpRewritePattern<memref::StoreOp> {
public:
  using OpRewritePattern<memref::StoreOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(memref::StoreOp op,
                                PatternRewriter &rewriter) const final {
    auto storeValue = op.getOperand(0);
    auto storeMemref = op.getOperand(1);
    
    auto loadOp = storeValue.getDefiningOp<memref::LoadOp>();
    if (!loadOp) {
      return failure();
    }
    auto loadMemref = loadOp.getOperand(0);

    bool isMemrefSame = storeMemref == loadMemref; 
    bool isIndexSame = true;

    // variadic index
    if (op.getNumOperands() > 2) {
      unsigned storeNumIndex = op.getNumOperands() - 2;
      unsigned loadNumIndex = loadOp.getNumOperands() - 1;
    
      if (storeNumIndex != loadNumIndex) {
        isIndexSame = false;
      } else {
        for (unsigned i=0; i<storeNumIndex; i++) {
          auto storeIndex = op.getOperand(2+i);
          auto loadIndex = loadOp.getOperand(1+i);
          isIndexSame = isIndexSame && (storeIndex == loadIndex); 
        }
      }
    }

    if (isMemrefSame && isIndexSame) {
      rewriter.eraseOp(op);
      return success();
    }

    return failure();
  }
};


class FinchLoopletRunRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(scf::ForOp forOp,
                                PatternRewriter &rewriter) const final {
    auto indVar = forOp.getInductionVar();
    
    OpBuilder builder(forOp);
    Location loc = forOp.getLoc();

    for (auto& accessOp : *forOp.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        auto accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          auto runLooplet = accessOp.getOperand(0).getDefiningOp<finch::RunOp>();
          if (!runLooplet) {
            continue;
          }
            
          Value runValue = runLooplet.getOperand(); 

          if (accessOp.getResultTypes()[0].isIndex()) {
            WalkResult walkResult = forOp.walk<WalkOrder::PreOrder>([&](finch::AccessOp aOp) {
                bool isFinalLevel = !(aOp->getResultTypes()[0].isIndex());
                if (!isFinalLevel) {
                  return WalkResult::advance();
                }
               
                // is final level aOp dependent to the accessOp?
                // if so, replace the value with run value
                Operation* op_ = aOp;
                while (isa<finch::AccessOp>(op_) || isa<finch::GetLevelOp>(op_)) {
                  if (isa<finch::AccessOp>(op_)) {
                    Operation* lvl = op_->getOperand(0).getDefiningOp();
                    op_ = lvl;
                  } else if (isa<finch::GetLevelOp>(op_)) {
                    Operation* access = op_->getOperand(1).getDefiningOp();
                    op_ = access;
                    if (access == &accessOp) {
                      rewriter.replaceOp(aOp, runValue);
                      return WalkResult::interrupt();
                    }
                  } 
                }
                
                return WalkResult::advance();
              }
            );
          } else {
            // Replace Access to Run Value
            rewriter.replaceOp(&accessOp, runValue);
          }


          return success();
        }
      }
    }
    
    return failure();
  }
};

class FinchLoopletSequenceRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(scf::ForOp forOp,
                                PatternRewriter &rewriter) const final {
    auto indVar = forOp.getInductionVar();
    
    OpBuilder builder(forOp);
    Location loc = forOp.getLoc();

    for (auto& accessOp : *forOp.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        auto accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          auto seqLooplet = accessOp.getOperand(0).getDefiningOp<finch::SequenceOp>();
          if (!seqLooplet) {
            //accessOp.emitWarning() << "No Sequence Looplet";
            continue;
          }
          
          rewriter.setInsertionPoint(forOp);
          // Main Sequence Rewrite          
          IRMapping mapper1;
          IRMapping mapper2;
          Operation* newForOp1 = rewriter.clone(*forOp, mapper1);
          Operation* newForOp2 = rewriter.clone(*forOp, mapper2);
          rewriter.moveOpAfter(newForOp1, forOp);
          rewriter.moveOpAfter(newForOp2, newForOp1);

          // Replace Access operand with Sequence bodies
          auto newAccess1 = mapper1.lookupOrDefault(&accessOp);
          auto newAccess2 = mapper2.lookupOrDefault(&accessOp);
          auto bodyLooplet1 = seqLooplet.getOperand(1);
          auto bodyLooplet2 = seqLooplet.getOperand(2);
          auto newBodyLooplet1 = mapper1.lookupOrDefault(bodyLooplet1);
          auto newBodyLooplet2 = mapper2.lookupOrDefault(bodyLooplet2);
          newAccess1->setOperand(0, newBodyLooplet1);
          newAccess2->setOperand(0, newBodyLooplet2);
          
          // Intersection
          Value loopLb = forOp.getLowerBound();
          Value loopUb = forOp.getUpperBound();

          //       firstBodyUb=secondBodyLb
          //                  v
          // [---firstBody---)[---secondBody---)
          Value firstBodyUb = seqLooplet.getOperand(0);
          Value secondBodyLb = firstBodyUb;
          if (!firstBodyUb.getType().isIndex()) {
            firstBodyUb = rewriter.create<arith::IndexCastOp>(
                loc, rewriter.getIndexType(), firstBodyUb);
            secondBodyLb = rewriter.create<arith::IndexCastOp>(
                loc, rewriter.getIndexType(), secondBodyLb);
          }         
          
          // Main intersect
          Value newFirstLoopUb = rewriter.create<arith::MinUIOp>(
              loc, loopUb, firstBodyUb);
          Value newSecondLoopLb = rewriter.create<arith::MaxUIOp>(
              loc, loopLb, secondBodyLb);
          cast<scf::ForOp>(newForOp1).setUpperBound(newFirstLoopUb);
          cast<scf::ForOp>(newForOp2).setLowerBound(newSecondLoopLb);

          rewriter.eraseOp(forOp);
          
          //llvm::outs() << *(newForOp1->getBlock()->getParentOp()->getBlock()->getParentOp()) << "\n";
          //llvm::outs() << "Done\n";
          return success();
        }
      }
    }
    
    return failure();
  }
};

class FinchLoopletStepperRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(scf::ForOp forOp,
                                PatternRewriter &rewriter) const final {
    auto indVar = forOp.getInductionVar();
    
    OpBuilder builder(forOp);
    Location loc = forOp.getLoc();

    // Collect all the steppers from accesses
    IRMapping mapper;
    SmallVector<finch::StepperOp, 4> stepperLooplets;
    SmallVector<finch::AccessOp, 4> accessOps;
    for (auto& accessOp : *forOp.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        Value accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          Operation* looplet = accessOp.getOperand(0).getDefiningOp();
          if (isa<finch::StepperOp>(looplet)) {
            // There can be multiple uses of this Stepper.
            // We don't want to erase original Stepper when lowering
            // because of other use.
            // So everytime we lower Stepper, clone it.
            Operation* clonedStepper = rewriter.clone(*looplet);  
            stepperLooplets.push_back(cast<finch::StepperOp>(clonedStepper));
            accessOps.push_back(cast<finch::AccessOp>(accessOp));
          }
        }
      }
    }

    if (stepperLooplets.empty()) {
      return failure();
    }

    // Main Stepper Rewrite        
    Value loopLowerBound = forOp.getLowerBound();
    Value loopUpperBound = forOp.getUpperBound();

    //llvm::outs() << "(1)\n";
    // Call Seek
    SmallVector<Value, 4> seekPositions;
    for (auto& stepperLooplet : stepperLooplets) {
      Block &seekBlock = stepperLooplet.getRegion(0).front();

      Operation* seekReturn = seekBlock.getTerminator();
      Value seekPosition = seekReturn->getOperand(0);
      rewriter.inlineBlockBefore(&seekBlock, forOp, ValueRange(loopLowerBound));
      seekPositions.push_back(seekPosition);
      rewriter.eraseOp(seekReturn); 
    }
 
    // create while Op
    seekPositions.push_back(loopLowerBound);
    unsigned numIterArgs = seekPositions.size();
    ValueRange iterArgs(seekPositions);
    scf::WhileOp whileOp = rewriter.create<scf::WhileOp>(
        loc, iterArgs.getTypes(), iterArgs);


    // fill condition
    SmallVector<Location, 4> locations(numIterArgs, loc);
    Block *before = rewriter.createBlock(&whileOp.getBefore(), {},
                                         iterArgs.getTypes(), locations);
    rewriter.setInsertionPointToEnd(before);
    Value cond = rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::ult,
                                                before->getArgument(numIterArgs-1), 
                                                loopUpperBound);
    rewriter.create<scf::ConditionOp>(loc, cond, before->getArguments());


    // after region of while op 
    Block *after = rewriter.createBlock(&whileOp.getAfter(), {},
                                        iterArgs.getTypes(), locations);

    rewriter.setInsertionPointToEnd(after);
    rewriter.moveOpBefore(forOp, after, after->end());
          

    //llvm::outs() << "(2)\n";
    // call stop then intersection
    rewriter.setInsertionPoint(forOp);
    SmallVector<Value, 4> stopCoords;
    Value intersectUpperBound = loopUpperBound;
    for (unsigned i = 0; i < stepperLooplets.size(); i++) {
      auto stepperLooplet = stepperLooplets[i];
      Block &stopBlock = stepperLooplet.getRegion(1).front();
      Operation* stopReturn = stopBlock.getTerminator();
      Value stopCoord = stopReturn->getOperand(0);
      rewriter.inlineBlockBefore(&stopBlock, forOp, after->getArgument(i));
      rewriter.eraseOp(stopReturn);
      if (!stopCoord.getType().isIndex()) {
        stopCoord = rewriter.create<arith::IndexCastOp>(
            loc, rewriter.getIndexType(), stopCoord);
      }
      intersectUpperBound = rewriter.create<arith::MinUIOp>(
          loc, intersectUpperBound, stopCoord);
      stopCoords.push_back(stopCoord);
    }
    forOp.setLowerBound(after->getArgument(numIterArgs-1));
    forOp.setUpperBound(intersectUpperBound); 



    //llvm::outs() << "(3)\n";
    //llvm::outs() << *(forOp->getBlock()->getParentOp()->getBlock()->getParentOp()) << "\n";

    // call body and replace access 
    for (unsigned i = 0; i < stepperLooplets.size(); i++) {
      auto stepperLooplet = stepperLooplets[i];      
      Block &bodyBlock = stepperLooplet.getRegion(2).front();
      Operation* bodyReturn = bodyBlock.getTerminator();
      Value bodyLooplet = bodyReturn->getOperand(0);
      rewriter.inlineBlockBefore(&bodyBlock, forOp, after->getArgument(i));
     
      //Operation* loopletOp = stepperLooplet;
      //Operation* accessOp = mapper.lookupOrDefault(loopletOp);
      //accessOp->setOperand(0, bodyLooplet);
      accessOps[i].setOperand(0, bodyLooplet);
      rewriter.eraseOp(bodyReturn);
    }
  
    //// current Upper Bound become next iteration's lower bound 
    rewriter.setInsertionPointToEnd(after);
    Value nextCoord = intersectUpperBound;

    //llvm::outs() << "(4)\n";
    //// call next
    SmallVector<Value,4> nextPositions;
    Type indexType = rewriter.getIndexType();
    for (unsigned i = 0; i < stepperLooplets.size(); i++) {
      auto stepperLooplet = stepperLooplets[i];            
      auto currPos = after->getArgument(i);
      auto stopCoord = stopCoords[i];

      Block &nextBlock = stepperLooplet.getRegion(3).front();
      Operation* nextReturn = nextBlock.getTerminator();
      Value nextPos = nextReturn->getOperand(0);
      
      rewriter.setInsertionPointToEnd(after);
      Value eq = rewriter.create<arith::CmpIOp>(
          loc, arith::CmpIPredicate::eq, stopCoord, intersectUpperBound);

      scf::IfOp ifOp = rewriter.create<scf::IfOp>(loc, indexType, eq, true);
      rewriter.setInsertionPointToStart(&ifOp.getThenRegion().front());
      scf::YieldOp thenYieldOp = rewriter.create<scf::YieldOp>(loc, nextPos);
      rewriter.inlineBlockBefore(&nextBlock, thenYieldOp, currPos);
      
      rewriter.setInsertionPointToStart(&ifOp.getElseRegion().front());
      scf::YieldOp elseYieldOp = rewriter.create<scf::YieldOp>(loc, currPos);
      
      nextPositions.push_back(ifOp.getResult(0));
      rewriter.eraseOp(nextReturn); 
    }
    nextPositions.push_back(nextCoord);
    rewriter.setInsertionPointToEnd(after);
    rewriter.create<scf::YieldOp>(loc, ValueRange(nextPositions));
    //llvm::outs() << *(forOp->getBlock()->getParentOp()->getBlock()->getParentOp()) << "\n";

    return success();
  }
};

class FinchInstantiate
    : public impl::FinchInstantiateBase<FinchInstantiate> {
public:
  using impl::FinchInstantiateBase<
      FinchInstantiate>::FinchInstantiateBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<FinchInstantiateRewriter>(&getContext());
    patterns.add<FinchNextLevelRewriter>(&getContext());
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};


class FinchSimplifier
    : public impl::FinchSimplifierBase<FinchSimplifier> {
public:
  using impl::FinchSimplifierBase<
      FinchSimplifier>::FinchSimplifierBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<FinchMemrefStoreLoadRewriter>(&getContext());
    patterns.add<FinchSemiringRewriter>(&getContext());
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};

class FinchLoopletRun
    : public impl::FinchLoopletRunBase<FinchLoopletRun> {
public:
  using impl::FinchLoopletRunBase<
      FinchLoopletRun>::FinchLoopletRunBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<FinchLoopletRunRewriter>(&getContext());
    patterns.add<FinchMemrefStoreLoadRewriter>(&getContext());
    patterns.add<FinchSemiringRewriter>(&getContext());
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};

class FinchLoopletSequence
    : public impl::FinchLoopletSequenceBase<FinchLoopletSequence> {
public:
  using impl::FinchLoopletSequenceBase<
      FinchLoopletSequence>::FinchLoopletSequenceBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<FinchLoopletSequenceRewriter>(&getContext()); 
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};

class FinchLoopletStepper
    : public impl::FinchLoopletStepperBase<FinchLoopletStepper> {
public:
  using impl::FinchLoopletStepperBase<
      FinchLoopletStepper>::FinchLoopletStepperBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<FinchLoopletStepperRewriter>(&getContext()); 
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};


class FinchLoopletPass
    : public impl::FinchLoopletPassBase<FinchLoopletPass> {
public:
  using impl::FinchLoopletPassBase<
      FinchLoopletPass>::FinchLoopletPassBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<FinchMemrefStoreLoadRewriter>(&getContext());
    patterns.add<FinchLoopletRunRewriter>(&getContext());
    patterns.add<FinchLoopletSequenceRewriter>(&getContext()); 
    patterns.add<FinchLoopletStepperRewriter>(&getContext()); 
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};





} // namespace
} // namespace mlir::finch

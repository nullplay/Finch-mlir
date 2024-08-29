//===- FinchPasses.cpp - Finch passes -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/PatternMatch.h"
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
#define GEN_PASS_DEF_FINCHSWITCHBARFOO
#define GEN_PASS_DEF_FINCHLOOPLETRUN
#define GEN_PASS_DEF_FINCHLOOPLETSEQUENCE
#define GEN_PASS_DEF_FINCHLOOPLETSTEPPER
#define GEN_PASS_DEF_FINCHLOOPLETPASS
#include "Finch/FinchPasses.h.inc"

namespace {
class FinchSwitchBarFooRewriter : public OpRewritePattern<func::FuncOp> {
public:
  using OpRewritePattern<func::FuncOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(func::FuncOp op,
                                PatternRewriter &rewriter) const final {
    if (op.getSymName() == "bar") {
      rewriter.modifyOpInPlace(op, [&op]() { op.setSymName("foo"); });
      return success();
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
            //accessOp.emitWarning() << "No Run Looplet";
            continue;
          }
          // Replace Access to Run Value
          Value runValue = runLooplet.getOperand(); 
          rewriter.replaceOp(&accessOp, runValue);

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
          
          // Intersect with Sequence Bound and Loop Bound
          //AffineMap currLowerMap = forOp.getLowerBound().getMap();
          //AffineMap currUpperMap = forOp.getLowerBound().getMap();
          //auto lbExprs = llvm::to_vector<4>(currLowerMap.getResults());
          //auto ubExprs = llvm::to_vector<4>(currUpperMap.getResults());
          //lbExprs.push_back(rewriter.getAffineSymbolExpr(
          //    currLowerMap.getNumSymbols()));
          //ubExprs.push_back(rewriter.getAffineSymbolExpr(
          //    currUpperMap.getNumSymbols()));
          //AffineMap newLowerMap = AffineMap::get(
          //    currLowerMap.getNumDims(),  
          //    currLowerMap.getNumSymbols()+1,  
          //    lbExprs, rewriter.getContext());
          //AffineMap newUpperMap = AffineMap::get(
          //    currUpperMap.getNumDims(),  
          //    currUpperMap.getNumSymbols()+1,  
          //    ubExprs, rewriter.getContext());

          //auto lbOperands = llvm::to_vector<4>(forOp.getLowerBoundOperands());
          //auto ubOperands = llvm::to_vector<4>(forOp.getUpperBoundOperands());
          //Value seqLb = rewriter.create<arith::IndexCastOp>( /* number->index */
          //    seqLooplet.getLoc(), rewriter.getIndexType(), seqLooplet.getOperand(0)); 
          //Value seqUb = rewriter.create<arith::IndexCastOp>( /* number->index */
          //    seqLooplet.getLoc(), rewriter.getIndexType(), seqLooplet.getOperand(1));
          //lbOperands.push_back(seqLb);
          //ubOperands.push_back(seqUb);

          //forOp.setLowerBound(ValueRange(lbOperands), newLowerMap);
          //forOp.setUpperBound(ValueRange(ubOperands), newUpperMap);


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
          Value firstBodyUb = seqLooplet.getOperand(0);
          Value c1 = rewriter.create<arith::ConstantIntOp>(
              loc, 1, firstBodyUb.getType().getIntOrFloatBitWidth());
          Value secondBodyLb = rewriter.create<arith::AddIOp>(
              loc, firstBodyUb, c1);
          // Main intersect
          Value firstBodyUbIndex = firstBodyUb;
          Value secondBodyLbIndex = secondBodyLb;
          if (!firstBodyUb.getType().isIndex()) {
            firstBodyUbIndex = rewriter.create<arith::IndexCastOp>(
                loc, rewriter.getIndexType(), firstBodyUb);
            secondBodyLbIndex = rewriter.create<arith::IndexCastOp>(
                loc, rewriter.getIndexType(), secondBodyLb);
          }
          Value newFirstLoopUb = rewriter.create<arith::MinUIOp>(
              loc, loopUb, firstBodyUbIndex);
          Value newSecondLoopLb = rewriter.create<arith::MaxUIOp>(
              loc, loopLb, secondBodyLbIndex);
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

    //llvm::outs() << *(op->getBlock()) << "\n";
    for (auto& accessOp : *forOp.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        auto accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          auto lookupLooplet = accessOp.getOperand(0).getDefiningOp<finch::StepperOp>();
          if (!lookupLooplet) {
            //accessOp.emitWarning() << "No Sequence Looplet";
            continue;
          }
          // llvm::outs() << "Start Stepper\n";
          //llvm::outs() << *(forOp->getBlock()->getParent()->getParentOp()->getBlock()) << "\n";
         
          // Main Stepper Rewrite        
          //llvm::outs() <<"START \n";
          auto lookupLooplet2 = rewriter.clone(*lookupLooplet);
          Block &seekBlock = lookupLooplet2->getRegion(0).front();
          Block &stopBlock = lookupLooplet2->getRegion(1).front();
          Block &bodyBlock = lookupLooplet2->getRegion(2).front();
          Block &nextBlock = lookupLooplet2->getRegion(3).front();

          Value loopLowerBound = forOp.getLowerBound();
          Value loopUpperBound = forOp.getUpperBound();
          
          // Call Seek 
          Operation* seekReturn = seekBlock.getTerminator();
          Value seekPosition = seekReturn->getOperand(0);
          rewriter.inlineBlockBefore(&seekBlock, forOp, ValueRange(loopLowerBound));
       
          // create while Op
          ValueRange iterArgs{seekPosition, loopLowerBound};
          scf::WhileOp whileOp = rewriter.create<scf::WhileOp>(
              loc, iterArgs.getTypes(), iterArgs);
          rewriter.eraseOp(seekReturn);

          // fill condition
          Block *before = rewriter.createBlock(&whileOp.getBefore(), {},
                                               iterArgs.getTypes(), {loc,loc});
          rewriter.setInsertionPointToEnd(before);
          Value cond = rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::ugt,
                                                      before->getArgument(1), 
                                                      loopUpperBound);
          rewriter.create<scf::ConditionOp>(loc, cond, before->getArguments());


          // after region of while op 
          Block *after = rewriter.createBlock(&whileOp.getAfter(), {},
                                              iterArgs.getTypes(), {loc,loc});

          rewriter.setInsertionPointToEnd(after);
          rewriter.moveOpBefore(forOp, after, after->end());

          // call stop
          Operation* stopReturn = stopBlock.getTerminator();
          Value stopCoord = stopReturn->getOperand(0);
          rewriter.inlineBlockBefore(&stopBlock, forOp, after->getArgument(0));
          rewriter.eraseOp(stopReturn);

          // intersection
          rewriter.setInsertionPoint(forOp);
          if (!stopCoord.getType().isIndex()) {
            stopCoord = rewriter.create<arith::IndexCastOp>(
                loc, rewriter.getIndexType(), stopCoord);
          }
          Value intersectUpperBound = rewriter.create<arith::MinUIOp>(
              loc, loopUpperBound, stopCoord);
          forOp.setLowerBound(after->getArgument(1));
          forOp.setUpperBound(intersectUpperBound); 

          // call body looplet of stepper
          Operation* bodyReturn = bodyBlock.getTerminator();
          Value bodyLooplet = bodyReturn->getOperand(0);
          rewriter.inlineBlockBefore(&bodyBlock, forOp, after->getArgument(0));
          
          accessOp.setOperand(0, bodyLooplet);
          rewriter.eraseOp(bodyReturn);
        
          // i = i + 1
          rewriter.setInsertionPointToEnd(after);
          Value nextCoord = rewriter.create<arith::AddIOp>(loc, after->getArgument(1), 
              rewriter.create<arith::ConstantIndexOp>(loc,1));

          // call next
          Operation* nextReturn = nextBlock.getTerminator();
          Value nextPos = nextReturn->getOperand(0);
          rewriter.inlineBlockBefore(&nextBlock, 
                                     nextCoord.getDefiningOp(), 
                                     after->getArgument(0));
          rewriter.create<scf::YieldOp>(loc, ValueRange{nextCoord, nextPos});
          rewriter.eraseOp(nextReturn); 

          return success();
        }
      }
    }
    
    return failure();
  }
};

class FinchSwitchBarFoo
    : public impl::FinchSwitchBarFooBase<FinchSwitchBarFoo> {
public:
  using impl::FinchSwitchBarFooBase<
      FinchSwitchBarFoo>::FinchSwitchBarFooBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    //patterns.add<FinchSwitchBarFooRewriter>(&getContext());
    patterns.add<FinchMemrefStoreLoadRewriter>(&getContext());
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

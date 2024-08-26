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

#include "Finch/FinchPasses.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir::finch {
#define GEN_PASS_DEF_FINCHSWITCHBARFOO
#define GEN_PASS_DEF_FINCHLOOPLETRUN
#define GEN_PASS_DEF_FINCHLOOPLETSEQUENCE
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

class FinchAffineStoreLoadRewriter : public OpRewritePattern<affine::AffineStoreOp> {
public:
  using OpRewritePattern<affine::AffineStoreOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(affine::AffineStoreOp op,
                                PatternRewriter &rewriter) const final {
    auto storeValue = op.getOperand(0);
    auto storeMemref = op.getOperand(1);
    auto storeAffineMap = op.getAffineMapAttr();
    
    auto loadOp = storeValue.getDefiningOp<affine::AffineLoadOp>();
    if (!loadOp) {
      return failure();
    }
    auto loadMemref = loadOp.getOperand(0);
    auto loadAffineMap = loadOp.getAffineMapAttr();

    bool isMemrefSame = storeMemref == loadMemref; 
    bool isAffineMapSame = storeAffineMap == loadAffineMap; 
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

    if (isMemrefSame && isIndexSame && isAffineMapSame) {
      rewriter.eraseOp(op);
      return success();
    }

    return failure();
  }
};


class FinchLoopletRunRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(scf::ForOp op,
                                PatternRewriter &rewriter) const final {
    auto indVar = op.getInductionVar();
    
    OpBuilder builder(op);
    Location loc = op.getLoc();

    for (auto& accessOp : *op.getBody()) {
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

  LogicalResult matchAndRewrite(scf::ForOp op,
                                PatternRewriter &rewriter) const final {
    auto indVar = op.getInductionVar();
    
    OpBuilder builder(op);
    Location loc = op.getLoc();

    for (auto& accessOp : *op.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        auto accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          auto seqLooplet = accessOp.getOperand(0).getDefiningOp<finch::SequenceOp>();
          if (!seqLooplet) {
            //accessOp.emitWarning() << "No Sequence Looplet";
            continue;
          }
          
          rewriter.setInsertionPoint(seqLooplet);
          // Intersect with Sequence Bound and Loop Bound
          //AffineMap currLowerMap = op.getLowerBound().getMap();
          //AffineMap currUpperMap = op.getLowerBound().getMap();
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

          //auto lbOperands = llvm::to_vector<4>(op.getLowerBoundOperands());
          //auto ubOperands = llvm::to_vector<4>(op.getUpperBoundOperands());
          //Value seqLb = rewriter.create<arith::IndexCastOp>( /* number->index */
          //    seqLooplet.getLoc(), rewriter.getIndexType(), seqLooplet.getOperand(0)); 
          //Value seqUb = rewriter.create<arith::IndexCastOp>( /* number->index */
          //    seqLooplet.getLoc(), rewriter.getIndexType(), seqLooplet.getOperand(1));
          //lbOperands.push_back(seqLb);
          //ubOperands.push_back(seqUb);

          //op.setLowerBound(ValueRange(lbOperands), newLowerMap);
          //op.setUpperBound(ValueRange(ubOperands), newUpperMap);


          // Main Sequence Rewrite          
          IRMapping mapper1;
          IRMapping mapper2;
          Operation* newForOp1 = rewriter.clone(*op, mapper1);
          Operation* newForOp2 = rewriter.clone(*op, mapper2);
          rewriter.moveOpAfter(newForOp1, op);
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
          Value loopLb = op.getLowerBound();
          Value loopUb = op.getUpperBound();
          Value firstBodyUb = seqLooplet.getOperand(0);
          Value c1 = 
              rewriter.create<arith::ConstantIntOp>(loc, 1, 
                  firstBodyUb.getType().getIntOrFloatBitWidth());
          Value secondBodyLb = 
              rewriter.create<arith::AddIOp>(loc, firstBodyUb, c1);
          // Main intersect
          Value firstBodyUbIndex = firstBodyUb;
          Value secondBodyLbIndex = secondBodyLb;
          if (!firstBodyUb.getType().isIndex()) {
            firstBodyUbIndex = 
              rewriter.create<arith::IndexCastOp>(loc, rewriter.getIndexType(), firstBodyUb);
            secondBodyLbIndex = 
              rewriter.create<arith::IndexCastOp>(loc, rewriter.getIndexType(), secondBodyLb);
          }
          Value newFirstLoopUb = 
              rewriter.create<arith::MinUIOp>(loc, loopUb, firstBodyUbIndex);
          Value newSecondLoopLb = 
              rewriter.create<arith::MaxUIOp>(loc, loopLb, secondBodyLbIndex);
          cast<scf::ForOp>(newForOp1).setUpperBound(newFirstLoopUb);
          cast<scf::ForOp>(newForOp2).setLowerBound(newSecondLoopLb);

          rewriter.eraseOp(op);

          return success();
        }
      }
    }
    
    return failure();
  }
};

class FinchLoopletLookupRewriter : public OpRewritePattern<scf::ForOp> {
public:
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(scf::ForOp op,
                                PatternRewriter &rewriter) const final {
    auto indVar = op.getInductionVar();
    
    OpBuilder builder(op);
    Location loc = op.getLoc();

    //llvm::outs() << *(op->getBlock()) << "\n";
    for (auto& accessOp : *op.getBody()) {
      if (isa<mlir::finch::AccessOp>(accessOp)) {
        auto accessVar = accessOp.getOperand(1);
        if (accessVar == indVar) {
          auto lookupLooplet = accessOp.getOperand(0).getDefiningOp<finch::LookupOp>();
          if (!lookupLooplet) {
            //accessOp.emitWarning() << "No Sequence Looplet";
            continue;
          }
          
          // Main Lookup Rewrite        
          llvm::outs() <<"START \n";
          Block &seekBlock = lookupLooplet.getRegion(0).front();
          Block &bodyBlock = lookupLooplet.getRegion(1).front();
          Block &nextBlock = lookupLooplet.getRegion(2).front();
          Operation* bodyReturn = bodyBlock.getTerminator();
          Value bodyLooplet = bodyReturn->getOperand(0); 

          // inline whole block into for loop 
          llvm::outs() <<"FirstStep \n";
          rewriter.inlineBlockBefore(&seekBlock, &accessOp, ValueRange(indVar));
          rewriter.inlineBlockBefore(&bodyBlock, &accessOp, std::nullopt);
          rewriter.inlineBlockBefore(&nextBlock, &accessOp, std::nullopt);

          // set AccessOp's operand to lookup body
          accessOp.setOperand(0, bodyLooplet); 
          rewriter.eraseOp(bodyReturn);
 
          // erase original Lookup Looplet
          llvm::outs() <<"ThirdStep \n";
          rewriter.eraseOp(lookupLooplet);

          llvm::outs() << op << "\n";
          llvm::outs() << "END \n";

         

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
    patterns.add<FinchAffineStoreLoadRewriter>(&getContext());
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
    patterns.add<FinchLoopletSequenceRewriter>(&getContext()); // To Sequence
    patterns.add<FinchLoopletLookupRewriter>(&getContext()); // To Sequence 
    //patterns.add<FinchLoopletRunRewriter>(&getContext());
    //patterns.add<FinchAffineStoreLoadRewriter>(&getContext());
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};



} // namespace
} // namespace mlir::finch

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


class FinchLoopletRunRewriter : public OpRewritePattern<affine::AffineForOp> {
public:
  using OpRewritePattern<affine::AffineForOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(affine::AffineForOp op,
                                PatternRewriter &rewriter) const final {
    auto indVar = op.getInductionVar();
    
    OpBuilder builder(op);
    Location loc = op.getLoc();

    for (auto& bodyOp : *op.getBody()) {
      if (isa<mlir::finch::AccessOp>(bodyOp)) {
        auto accessVar = bodyOp.getOperand(1);
        if (accessVar == indVar) {
          auto runLooplet = bodyOp.getOperand(0).getDefiningOp<finch::RunOp>();
          if (!runLooplet) {
            //bodyOp.emitWarning() << "No Run Looplet";
            continue;
          }

          rewriter.setInsertionPoint(runLooplet);
          
          // Intersect with Sequence Bound and Loop Bound
          AffineMap currLowerMap = op.getLowerBound().getMap();
          AffineMap currUpperMap = op.getLowerBound().getMap();
          auto lbExprs = llvm::to_vector<4>(currLowerMap.getResults());
          auto ubExprs = llvm::to_vector<4>(currUpperMap.getResults());
          lbExprs.push_back(rewriter.getAffineSymbolExpr(
              currLowerMap.getNumSymbols()));
          ubExprs.push_back(rewriter.getAffineSymbolExpr(
              currUpperMap.getNumSymbols()));
          AffineMap newLowerMap = AffineMap::get(
              currLowerMap.getNumDims(),  
              currLowerMap.getNumSymbols()+1,  
              lbExprs, rewriter.getContext());
          AffineMap newUpperMap = AffineMap::get(
              currUpperMap.getNumDims(),  
              currUpperMap.getNumSymbols()+1,  
              ubExprs, rewriter.getContext());

          //llvm::outs() << currLowerMap << "\n";
          //llvm::outs() << newLowerMap << "\n\n";

          auto lbOperands = llvm::to_vector<4>(op.getLowerBoundOperands());
          auto ubOperands = llvm::to_vector<4>(op.getUpperBoundOperands());
          
          Value runLb = rewriter.create<arith::IndexCastOp>( /* number->index */
              runLooplet.getLoc(), rewriter.getIndexType(), runLooplet.getOperand(0)); 
          Value runUb = rewriter.create<arith::IndexCastOp>( /* number->index */
              runLooplet.getLoc(), rewriter.getIndexType(), runLooplet.getOperand(1)); 
          lbOperands.push_back(runLb);
          ubOperands.push_back(runUb);
 
          //for (auto x: op.getLowerBoundOperands()) 
          //  llvm::outs() << x << " ";
          //llvm::outs() << "\n";
          //for (auto x: lbOperands) 
          //  llvm::outs() << x << " ";
          //llvm::outs() << "\n\n";

          op.setLowerBound(ValueRange(lbOperands), newLowerMap);
          op.setUpperBound(ValueRange(ubOperands), newUpperMap);

          // Replace Access to Run Value
          Value runValue = runLooplet.getOperand(2); 
          rewriter.replaceOp(&bodyOp, runValue);

          //llvm::outs() << op << "\n\n";
          //llvm::outs() << *(op->getBlock()) << "\n\n";

          return success();
        }
      }
    }
    
    return failure();
  }
};

class FinchLoopletSequenceRewriter : public OpRewritePattern<affine::AffineForOp> {
public:
  using OpRewritePattern<affine::AffineForOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(affine::AffineForOp op,
                                PatternRewriter &rewriter) const final {
    auto indVar = op.getInductionVar();
    
    OpBuilder builder(op);
    Location loc = op.getLoc();

    for (auto& bodyOp : *op.getBody()) {
      if (isa<mlir::finch::AccessOp>(bodyOp)) {
        auto accessVar = bodyOp.getOperand(1);
        if (accessVar == indVar) {
          auto seqLooplet = bodyOp.getOperand(0).getDefiningOp<finch::SequenceOp>();
          if (!seqLooplet) {
            //bodyOp.emitWarning() << "No Sequence Looplet";
            continue;
          }
          
          rewriter.setInsertionPoint(seqLooplet);
          // Intersect with Sequence Bound and Loop Bound
          AffineMap currLowerMap = op.getLowerBound().getMap();
          AffineMap currUpperMap = op.getLowerBound().getMap();
          auto lbExprs = llvm::to_vector<4>(currLowerMap.getResults());
          auto ubExprs = llvm::to_vector<4>(currUpperMap.getResults());
          lbExprs.push_back(rewriter.getAffineSymbolExpr(
              currLowerMap.getNumSymbols()));
          ubExprs.push_back(rewriter.getAffineSymbolExpr(
              currUpperMap.getNumSymbols()));
          AffineMap newLowerMap = AffineMap::get(
              currLowerMap.getNumDims(),  
              currLowerMap.getNumSymbols()+1,  
              lbExprs, rewriter.getContext());
          AffineMap newUpperMap = AffineMap::get(
              currUpperMap.getNumDims(),  
              currUpperMap.getNumSymbols()+1,  
              ubExprs, rewriter.getContext());

          auto lbOperands = llvm::to_vector<4>(op.getLowerBoundOperands());
          auto ubOperands = llvm::to_vector<4>(op.getUpperBoundOperands());
          Value seqLb = rewriter.create<arith::IndexCastOp>( /* number->index */
              seqLooplet.getLoc(), rewriter.getIndexType(), seqLooplet.getOperand(0)); 
          Value seqUb = rewriter.create<arith::IndexCastOp>( /* number->index */
              seqLooplet.getLoc(), rewriter.getIndexType(), seqLooplet.getOperand(1));
          lbOperands.push_back(seqLb);
          ubOperands.push_back(seqUb);

          op.setLowerBound(ValueRange(lbOperands), newLowerMap);
          op.setUpperBound(ValueRange(ubOperands), newUpperMap);


          // Main Sequence Rewrite          
          Operation* prevForOp = op;
          unsigned numBodyLooplets = seqLooplet.getNumOperands() - 2;
          for (unsigned i = 0; i < numBodyLooplets; i++) {
            auto bodyLooplet = seqLooplet.getOperand(2+i);
 
            SmallVector<Value, 4> operands;
            llvm::append_range(operands, op.getLowerBoundOperands());
            llvm::append_range(operands, op.getUpperBoundOperands());
            if (i==0) {
              llvm::append_range(operands, op.getInits());
            } else {
              llvm::append_range(operands, prevForOp->getResults());
            }

            IRMapping mapper;
            Operation* newForOp = rewriter.clone(*op, mapper);
            rewriter.moveOpAfter(newForOp, prevForOp);
            rewriter.replaceAllUsesWith(prevForOp->getResults(), newForOp->getResults());
            newForOp->setOperands(operands);
            prevForOp = newForOp;

            auto newAccess = mapper.lookupOrNull(&bodyOp);
            newAccess->setOperand(0, bodyLooplet);

          }
         
          rewriter.eraseOp(op);

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
    //patterns.add<FinchLoopletRunRewriter>(&getContext());
    //patterns.add<FinchAffineStoreLoadRewriter>(&getContext());
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};




} // namespace
} // namespace mlir::finch

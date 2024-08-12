//===- StandalonePasses.cpp - Standalone passes -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Rewrite/FrozenRewritePatternSet.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"

#include "Standalone/StandalonePasses.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir::standalone {
#define GEN_PASS_DEF_STANDALONESWITCHBARFOO
#define GEN_PASS_DEF_STANDALONELOOPLETRUN
#include "Standalone/StandalonePasses.h.inc"

namespace {
class StandaloneSwitchBarFooRewriter : public OpRewritePattern<func::FuncOp> {
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

class StandaloneLoopletRunRewriter : public OpRewritePattern<affine::AffineForOp> {
public:
  using OpRewritePattern<affine::AffineForOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(affine::AffineForOp op,
                                PatternRewriter &rewriter) const final {
    auto indVar = op.getInductionVar();
    
    OpBuilder builder(op);
    Location loc = op.getLoc();

    for (auto& bodyOp : *op.getBody()) {
      if (isa<mlir::standalone::AccessOp>(bodyOp)) {
        auto accessVar = bodyOp.getOperand(1);
        if (accessVar == indVar) {
          auto runLooplet = bodyOp.getOperand(0).getDefiningOp<standalone::RunOp>();
          if (!runLooplet) {
            bodyOp.emitWarning() << "No Run Looplet";
            continue;
          }
         
          // Setup New Map for Min/Max
          SmallVector<AffineExpr, 4> Exprs;
          Exprs.push_back(builder.getAffineSymbolExpr(0));
          Exprs.push_back(builder.getAffineSymbolExpr(1));
          AffineMap newmap = AffineMap::get(
              0, /* NumDims */ 
              2, /* NumSymbols */ 
              Exprs, builder.getContext());

          // Setup New Operands for Min/Max
          SmallVector<Value, 4> lowerBoundOperands;
          SmallVector<Value, 4> upperBoundOperands;
          Value forLb = op.getLowerBoundOperands()[0];
          Value forUb = op.getUpperBoundOperands()[0];
          Value runLb = runLooplet.getOperand(0);
          Value runUb = runLooplet.getOperand(1);
          Value runLbToIndex = rewriter.create<arith::IndexCastOp>(
              loc, rewriter.getIndexType(), runLb); /* number->index */
          Value runUbToIndex = rewriter.create<arith::IndexCastOp>(
              loc, rewriter.getIndexType(), runUb); /* number->index */
          lowerBoundOperands.push_back(forLb);
          lowerBoundOperands.push_back(runLbToIndex);
          upperBoundOperands.push_back(forUb);
          upperBoundOperands.push_back(runUbToIndex);
         
          //Intersect Loop and Run Bound 
          Value newLb = rewriter.create<affine::AffineMaxOp>(
              loc, newmap, lowerBoundOperands);
          Value newUb = rewriter.create<affine::AffineMinOp>(
              loc, newmap, upperBoundOperands);

          // Update AffineFor Bounds
          AffineMap origLowerMap = op.getLowerBound().getMap();
          AffineMap origUpperMap = op.getUpperBound().getMap();
          op.setLowerBound(ValueRange(newLb), origLowerMap);
          op.setUpperBound(ValueRange(newUb), origUpperMap);
          
          // Replace Access to Run Value
          Value runValue = runLooplet.getOperand(2); 
          rewriter.replaceOp(&bodyOp, runValue);

          return success();
        }
      }
    }
    
    return failure();
  }
};


class StandaloneSwitchBarFoo
    : public impl::StandaloneSwitchBarFooBase<StandaloneSwitchBarFoo> {
public:
  using impl::StandaloneSwitchBarFooBase<
      StandaloneSwitchBarFoo>::StandaloneSwitchBarFooBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<StandaloneSwitchBarFooRewriter>(&getContext());
    //patterns.add<StandaloneLoopletRunRewriter>(&getContext());
    
    applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
    
    //FrozenRewritePatternSet patternSet(std::move(patterns));
    //if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
    //  signalPassFailure();
  }
};

class StandaloneLoopletRun
    : public impl::StandaloneLoopletRunBase<StandaloneLoopletRun> {
public:
  using impl::StandaloneLoopletRunBase<
      StandaloneLoopletRun>::StandaloneLoopletRunBase;
  void runOnOperation() final {
    RewritePatternSet patterns(&getContext());
    patterns.add<StandaloneLoopletRunRewriter>(&getContext());
    FrozenRewritePatternSet patternSet(std::move(patterns));
    if (failed(applyPatternsAndFoldGreedily(getOperation(), patternSet)))
      signalPassFailure();
  }
};

} // namespace
} // namespace mlir::standalone

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
    auto forUb = op.getUpperBoundOperands(); 
    
    AffineMap orgmap, newmap; 
    OpBuilder builder(op);
    Location loc = op.getLoc();
   
    orgmap = (op.getLowerBound().getMap());
   
    //llvm::outs() << "hello" << "\n" << op.getLowerBoundOperands().size();
    //llvm::outs() << orgmap.getNumDims() << " vs " << orgmap.getNumSymbols() << "\n";
    //llvm::outs() << newmap << "\n";
    

    llvm::outs() << "Hi \n" ;

    //if (op.hasConstantLowerBound()) {
    //  llvm::outs() << op.getConstantLowerBound() << "\n";
    //} else {
    //  auto forLb = op.getLowerBoundOperands(); 
    //  llvm::outs() << forLb[0] << "\n";
    //}

    for (auto& bodyOp : *op.getBody()) {
      if (isa<mlir::standalone::AccessOp>(bodyOp)) {
        auto accessVar = bodyOp.getOperand(1);
        if (accessVar == indVar) {
          auto runLooplet = bodyOp.getOperand(0).getDefiningOp<standalone::RunOp>();
          if (!runLooplet) {
            bodyOp.emitWarning() << "No Run Looplet";
            continue;
            //return failure();
          }
          auto runValue = runLooplet.getOperand(2).getDefiningOp(); 
          
          auto runLb = runLooplet.getOperand(0);
          auto loopLb = op.getLowerBoundOperands()[0];
          auto runUb = runLooplet.getOperand(1);

          // Setup New Map
          SmallVector<AffineExpr, 4> Exprs;
          Exprs.push_back(builder.getAffineSymbolExpr(0));
          Exprs.push_back(builder.getAffineSymbolExpr(1));
          newmap = AffineMap::get(orgmap.getNumDims(), 2, Exprs, builder.getContext());

          //Setup New Operands
          SmallVector<Value, 4> newoperands;
          newoperands.push_back(loopLb);
          
          auto newrunLb = rewriter.create<arith::IndexCastOp>(loc, rewriter.getIndexType(), runLb);
          newoperands.push_back(newrunLb);
          
          auto newLb = rewriter.create<affine::AffineMaxOp>(loc, newmap, newoperands);
          ValueRange newLbOperands = ValueRange(newLb);

          op.setLowerBound(newLbOperands, orgmap);
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

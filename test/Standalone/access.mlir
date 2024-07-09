// RUN: standalone-opt %s | standalone-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        %1 = index.castu %0 : i32 to index
        // CHECK: %{{.*}} = standalone.foo %{{.*}} : i32
        %res = standalone.foo %0 : i32
       
        %val = arith.constant 3.0 : f32
        // CHECK: %{{.*}} = standalone.run %{{.*}} %{{.*}} %{{.*}} : i32, i32, f32 to !standalone.looplet 
        %3 = standalone.run %0 %0 %val : i32, i32, f32 to !standalone.looplet 

        // CHECK: %{{.*}} = standalone.access %{{.*}} %{{.*}} : !standalone.looplet, index to f32
        %2 = standalone.access %3 %1 : !standalone.looplet, index to f32 
 
        return
    }

    // CHECK-LABEL: func @standalone_types(%arg0: !standalone.custom<"10">)
    func.func @standalone_types(%arg0: !standalone.custom<"10">) {
        return
    }
}

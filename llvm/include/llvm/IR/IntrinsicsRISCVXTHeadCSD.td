//===- IntrinsicsRISCVXTHeadCSD.td - Defines RISCV XTHead intrinsics -----------
//-------------------------*- tablegen -*----------------------------------===//
//
// Created by: Nikos Boumakis, csdp1358
// For: HY546-Types and Programming Languages project
// Date: 29/1/2024
// Email: boumakis@csd.uoc.gr
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the RISCV-specific intrinsics for the XTHeadCmo and
// XTHeadSync extensions, as required for the HY546 project.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//


let TargetPrefix = "riscv" in {
    class THeadNoOperands : DefaultAttrsIntrinsic<[], [], [IntrHasSideEffects, IntrNoMem]>;
    class THeadPtrOperand : DefaultAttrsIntrinsic<[], [llvm_anyptr_ty], [IntrHasSideEffects, IntrNoMem]>;
    class THeadScalarOperand : DefaultAttrsIntrinsic<[], [llvm_i64_ty], [IntrHasSideEffects, IntrNoMem]>;
    class THeadPtrScalarOperand : DefaultAttrsIntrinsic<[], [llvm_anyptr_ty, llvm_i64_ty], [IntrHasSideEffects, IntrNoMem]>;

    def int_riscv_thdcache_call : THeadNoOperands;
    def int_riscv_thdcache_ciall : THeadNoOperands;
    def int_riscv_thdcache_iall : THeadNoOperands;
    def int_riscv_thdcache_cpa : THeadPtrOperand;
    def int_riscv_thdcache_cipa : THeadPtrOperand;
    def int_riscv_thdcache_ipa : THeadPtrOperand;
    def int_riscv_thdcache_cva : THeadPtrOperand;
    def int_riscv_thdcache_civa : THeadPtrOperand;
    def int_riscv_thdcache_iva : THeadPtrOperand;
    def int_riscv_thdcache_csw : THeadScalarOperand;
    def int_riscv_thdcache_cisw : THeadScalarOperand;
    def int_riscv_thdcache_isw : THeadScalarOperand;
    def int_riscv_thdcache_cpal1 : THeadPtrOperand;
    def int_riscv_thdcache_cval1 : THeadPtrOperand;

    def int_riscv_thicache_iall : THeadNoOperands;
    def int_riscv_thicache_ialls : THeadNoOperands;
    def int_riscv_thicache_ipa : THeadPtrOperand;
    def int_riscv_thicache_iva : THeadPtrOperand;

    def int_riscv_thl2cache_call : THeadNoOperands;
    def int_riscv_thl2cache_ciall : THeadNoOperands;
    def int_riscv_thl2cache_iall : THeadNoOperands;

    def int_riscv_thsfence_vmas : THeadPtrScalarOperand;
    def int_riscv_thsync : THeadNoOperands;
    def int_riscv_thsync_s : THeadNoOperands;
    def int_riscv_thsync_i : THeadNoOperands;
    def int_riscv_thsync_is : THeadNoOperands;
}

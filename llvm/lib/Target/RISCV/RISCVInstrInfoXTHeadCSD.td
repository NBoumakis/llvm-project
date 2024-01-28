//===-- RISCVInstrInfoXTHeadCSD.td -------------------------*- tablegen -*-===//
//
// Created by: Nikos Boumakis, csdp1358
// For: HY546-Types and Programming Languages project
// Date: 29/1/2024
// Email: boumakis@csd.uoc.gr
//
//===----------------------------------------------------------------------===//
//
// This file describes the patterns for converting RISC-V XTHead vendor
// extension intrinsics into target instructions.
// The extensions defined by T-Head of Alibaba.
//
//===----------------------------------------------------------------------===//


let Predicates = [HasVendorXTHeadCmo] in {
def : Pat<(int_riscv_thdcache_call), (TH_DCACHE_CALL)>;
def : Pat<(int_riscv_thdcache_ciall), (TH_DCACHE_CIALL)>;
def : Pat<(int_riscv_thdcache_iall), (TH_DCACHE_IALL)>;
def : Pat<(int_riscv_thdcache_cpa GPR:$a), (TH_DCACHE_CPA GPR:$a)>;
def : Pat<(int_riscv_thdcache_cipa GPR:$a), (TH_DCACHE_CIPA GPR:$a)>;
def : Pat<(int_riscv_thdcache_ipa GPR:$a), (TH_DCACHE_IPA GPR:$a)>;
def : Pat<(int_riscv_thdcache_cva GPR:$a), (TH_DCACHE_CVA GPR:$a)>;
def : Pat<(int_riscv_thdcache_civa GPR:$a), (TH_DCACHE_CIVA GPR:$a)>;
def : Pat<(int_riscv_thdcache_iva GPR:$a), (TH_DCACHE_IVA GPR:$a)>;
def : Pat<(int_riscv_thdcache_csw GPR:$a), (TH_DCACHE_CSW GPR:$a)>;
def : Pat<(int_riscv_thdcache_cisw GPR:$a), (TH_DCACHE_CISW GPR:$a)>;
def : Pat<(int_riscv_thdcache_isw GPR:$a), (TH_DCACHE_ISW GPR:$a)>;
def : Pat<(int_riscv_thdcache_cpal1 GPR:$a), (TH_DCACHE_CPAL1 GPR:$a)>;
def : Pat<(int_riscv_thdcache_cval1 GPR:$a), (TH_DCACHE_CVAL1 GPR:$a)>;

def : Pat<(int_riscv_thicache_iall), (TH_ICACHE_IALL)>;
def : Pat<(int_riscv_thicache_ialls), (TH_ICACHE_IALLS)>;
def : Pat<(int_riscv_thicache_ipa GPR:$a), (TH_ICACHE_IPA GPR:$a)>;
def : Pat<(int_riscv_thicache_iva GPR:$a), (TH_ICACHE_IVA $a)>;

def : Pat<(int_riscv_thl2cache_call), (TH_L2CACHE_CALL)>;
def : Pat<(int_riscv_thl2cache_ciall), (TH_L2CACHE_CIALL)>;
def : Pat<(int_riscv_thl2cache_iall), (TH_L2CACHE_IALL)>;
}

let Predicates = [HasVendorXTHeadSync] in {
def : Pat<(int_riscv_thsfence_vmas GPR:$a, GPR:$b), (TH_SFENCE_VMAS GPR:$a, GPR:$b)>;
def : Pat<(int_riscv_thsync), (TH_SYNC)>;
def : Pat<(int_riscv_thsync_s), (TH_SYNC_S)>;
def : Pat<(int_riscv_thsync_i), (TH_SYNC_I)>;
def : Pat<(int_riscv_thsync_is), (TH_SYNC_IS)>;
}

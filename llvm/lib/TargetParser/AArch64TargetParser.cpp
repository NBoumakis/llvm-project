//===-- AArch64TargetParser - Parser for AArch64 features -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a target parser to recognise AArch64 hardware features
// such as FPU/CPU/ARCH and extension names.
//
//===----------------------------------------------------------------------===//

#include "llvm/TargetParser/AArch64TargetParser.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/ARMTargetParserCommon.h"
#include "llvm/TargetParser/Triple.h"
#include <cctype>

using namespace llvm;

static unsigned checkArchVersion(llvm::StringRef Arch) {
  if (Arch.size() >= 2 && Arch[0] == 'v' && std::isdigit(Arch[1]))
    return (Arch[1] - 48);
  return 0;
}

std::optional<AArch64::ArchInfo> AArch64::getArchForCpu(StringRef CPU) {
  if (CPU == "generic")
    return ARMV8A;

  // Note: this now takes cpu aliases into account
  std::optional<CpuInfo> Cpu = parseCpu(CPU);
  if (!Cpu)
    return {};
  return Cpu->Arch;
}

std::optional<AArch64::ArchInfo> AArch64::ArchInfo::findBySubArch(StringRef SubArch) {
  for (const auto *A : AArch64::ArchInfos)
    if (A->getSubArch() == SubArch)
      return *A;
  return {};
}

uint64_t AArch64::getCpuSupportsMask(ArrayRef<StringRef> FeatureStrs) {
  uint64_t FeaturesMask = 0;
  for (const StringRef &FeatureStr : FeatureStrs) {
    if (auto Ext = parseArchExtension(FeatureStr))
      FeaturesMask |= (1ULL << Ext->CPUFeature);
  }
  return FeaturesMask;
}

bool AArch64::getExtensionFeatures(
    const AArch64::ExtensionBitset &InputExts,
    std::vector<StringRef> &Features) {
  for (const auto &E : Extensions)
    /* INVALID and NONE have no feature name. */
    if (InputExts.test(E.ID) && !E.Feature.empty())
      Features.push_back(E.Feature);

  return true;
}

StringRef AArch64::resolveCPUAlias(StringRef Name) {
  for (const auto &A : CpuAliases)
    if (A.Alias == Name)
      return A.Name;
  return Name;
}

StringRef AArch64::getArchExtFeature(StringRef ArchExt) {
  bool IsNegated = ArchExt.starts_with("no");
  StringRef ArchExtBase = IsNegated ? ArchExt.drop_front(2) : ArchExt;

  if (auto AE = parseArchExtension(ArchExtBase)) {
    // Note: the returned string can be empty.
    return IsNegated ? AE->NegFeature : AE->Feature;
  }

  return StringRef();
}

void AArch64::fillValidCPUArchList(SmallVectorImpl<StringRef> &Values) {
  for (const auto &C : CpuInfos)
      Values.push_back(C.Name);

  for (const auto &Alias : CpuAliases)
    Values.push_back(Alias.Alias);
}

bool AArch64::isX18ReservedByDefault(const Triple &TT) {
  return TT.isAndroid() || TT.isOSDarwin() || TT.isOSFuchsia() ||
         TT.isOSWindows() || TT.isOHOSFamily();
}

// Allows partial match, ex. "v8a" matches "armv8a".
std::optional<AArch64::ArchInfo> AArch64::parseArch(StringRef Arch) {
  Arch = llvm::ARM::getCanonicalArchName(Arch);
  if (checkArchVersion(Arch) < 8)
    return {};

  StringRef Syn = llvm::ARM::getArchSynonym(Arch);
  for (const auto *A : ArchInfos) {
    if (A->Name.ends_with(Syn))
      return *A;
  }
  return {};
}

std::optional<AArch64::ExtensionInfo> AArch64::parseArchExtension(StringRef ArchExt) {
  for (const auto &A : Extensions) {
    if (ArchExt == A.Name)
      return A;
  }
  return {};
}

std::optional<AArch64::CpuInfo> AArch64::parseCpu(StringRef Name) {
  // Resolve aliases first.
  Name = resolveCPUAlias(Name);

  // Then find the CPU name.
  for (const auto &C : CpuInfos)
    if (Name == C.Name)
      return C;

  return {};
}

void AArch64::PrintSupportedExtensions(StringMap<StringRef> DescMap) {
  outs() << "All available -march extensions for AArch64\n\n"
         << "    " << left_justify("Name", 20)
         << (DescMap.empty() ? "\n" : "Description\n");
  for (const auto &Ext : Extensions) {
    // Extensions without a feature cannot be used with -march.
    if (!Ext.Feature.empty()) {
      std::string Description = DescMap[Ext.Name].str();
      outs() << "    "
             << format(Description.empty() ? "%s\n" : "%-20s%s\n",
                       Ext.Name.str().c_str(), Description.c_str());
    }
  }
}

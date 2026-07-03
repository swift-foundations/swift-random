// Exports.swift
// Re-exports for swift-random umbrella module.

@_exported public import Random_Primitives

#if canImport(Darwin)
    @_exported public import Darwin_Kernel  // Brings Random.fill() for Darwin
#elseif canImport(Glibc) || canImport(Musl)
    @_exported public import Linux_Kernel  // Brings Random.fill() for Linux
#elseif os(Windows)
    @_exported public import Windows_Kernel  // Brings Random.fill() for Windows
#endif

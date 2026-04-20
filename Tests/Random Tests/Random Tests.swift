// Random Tests.swift

import Testing
import Testing
@testable import Random

extension Random {
    enum Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Unit Tests

extension Random.Test.Unit {
    @Test
    func `bytes(count:) returns empty array for count 0`() throws {
        let bytes = try Random.bytes(count: 0)
        #expect(bytes.isEmpty)
    }

    @Test
    func `bytes(count:) returns correct length`() throws {
        let bytes = try Random.bytes(count: 32)
        #expect(bytes.count == 32)
    }

    @Test
    func `fill(_:) fills buffer with random bytes`() throws {
        var buffer = [UInt8](repeating: 0, count: 32)
        try buffer.withUnsafeMutableBytes { ptr in
            try Random.fill(ptr)
        }
        // At least some bytes should be non-zero (statistically certain)
        #expect(buffer.contains { $0 != 0 })
    }

    @Test
    func `fill(_:) handles empty buffer`() throws {
        var buffer: [UInt8] = []
        try buffer.withUnsafeMutableBytes { ptr in
            try Random.fill(ptr)
        }
        #expect(buffer.isEmpty)
    }
}

// MARK: - Edge Cases

extension Random.Test.EdgeCase {
    @Test
    func `bytes(count:) generates different values on successive calls`() throws {
        let bytes1 = try Random.bytes(count: 16)
        let bytes2 = try Random.bytes(count: 16)
        // Statistically, two 128-bit random values should never be equal
        #expect(bytes1 != bytes2)
    }

    @Test
    func `bytes(count:) handles large buffers (1 MB)`() throws {
        let bytes = try Random.bytes(count: 1024 * 1024)
        #expect(bytes.count == 1024 * 1024)
    }
}

// MARK: - Performance

extension Random.Test.Performance {
    @Test("bytes(count: 32) generation", .timed(iterations: 100, warmup: 10))
    func bytesGeneration() throws {
        _ = try Random.bytes(count: 32)
    }

    @Test("fill 1KB buffer", .timed(iterations: 100, warmup: 10))
    func fill1KB() throws {
        var buffer = [UInt8](repeating: 0, count: 1024)
        try buffer.withUnsafeMutableBytes { ptr in
            try Random.fill(ptr)
        }
    }
}

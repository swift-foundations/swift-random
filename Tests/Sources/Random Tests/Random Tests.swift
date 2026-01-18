// Random Tests.swift

import Testing
import Testing
@testable import Random

extension Random {
    #Tests
}

// MARK: - Unit Tests

extension Random.Test.Unit {
    @Test("bytes(count:) returns empty array for count 0")
    func bytesEmptyForZero() throws {
        let bytes = try Random.bytes(count: 0)
        #expect(bytes.isEmpty)
    }

    @Test("bytes(count:) returns correct length")
    func bytesCorrectLength() throws {
        let bytes = try Random.bytes(count: 32)
        #expect(bytes.count == 32)
    }

    @Test("fill(_:) fills buffer with random bytes")
    func fillsBuffer() throws {
        var buffer = [UInt8](repeating: 0, count: 32)
        try buffer.withUnsafeMutableBytes { ptr in
            try Random.fill(ptr)
        }
        // At least some bytes should be non-zero (statistically certain)
        #expect(buffer.contains { $0 != 0 })
    }

    @Test("fill(_:) handles empty buffer")
    func fillEmptyBuffer() throws {
        var buffer: [UInt8] = []
        try buffer.withUnsafeMutableBytes { ptr in
            try Random.fill(ptr)
        }
        #expect(buffer.isEmpty)
    }
}

// MARK: - Edge Cases

extension Random.Test.EdgeCase {
    @Test("bytes(count:) generates different values on successive calls")
    func differentValues() throws {
        let bytes1 = try Random.bytes(count: 16)
        let bytes2 = try Random.bytes(count: 16)
        // Statistically, two 128-bit random values should never be equal
        #expect(bytes1 != bytes2)
    }

    @Test("bytes(count:) handles large buffers (1 MB)")
    func largeBuffer() throws {
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

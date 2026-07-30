// Random Tests.swift

import Testing

@testable import Random

extension Random {
    enum Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
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
    func `bytes(count:) preserves Random.Error in its public signature`() {
        // Compile-time proof: the convenience API's typed error is Random.Error,
        // not an erased Swift.Error.
        let typed: (Int) throws(Random.Error) -> [UInt8] = Random.bytes(count:)

        // The typed catch binds the concrete Random.Error without erasure.
        do throws(Random.Error) {
            _ = try typed(16)
        } catch {
            let concrete: Random.Error = error
            Issue.record("Random.bytes(count:) failed unexpectedly: \(concrete)")
        }
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

extension Random.Test.`Edge Case` {
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

// Random Performance Tests.swift

import Random
import Testing

extension Random {
    enum Test {
        @Suite(.serialized) struct Performance {}
    }
}

extension Random.Test.Performance {
    @Test(.timed(iterations: 100, warmup: 10))
    func `bytes(count: 32) generation`() throws {
        _ = try Random.bytes(count: 32)
    }

    @Test(.timed(iterations: 100, warmup: 10))
    func `fill 1KB buffer`() throws {
        var buffer = [UInt8](repeating: 0, count: 1024)
        try buffer.withUnsafeMutableBytes { ptr in
            try Random.fill(ptr)
        }
    }
}

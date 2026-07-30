// Random.Convenience.swift
// Convenience methods for random byte generation.

extension Random {
    /// Returns an array of cryptographically-secure random bytes.
    ///
    /// This is a convenience wrapper around `fill(_:)` that allocates
    /// and returns an array of the requested size.
    ///
    /// - Parameter count: The number of random bytes to generate.
    /// - Returns: An array containing `count` random bytes.
    /// - Throws: `Random.Error` if random bytes cannot be generated.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Generate a 256-bit key
    /// let key = try Random.bytes(count: 32)
    ///
    /// // Generate a nonce
    /// let nonce = try Random.bytes(count: 12)
    /// ```
    public static func bytes(count: Int) throws(Random.Error) -> [UInt8] {
        guard count > 0 else { return [] }
        var result = [UInt8](repeating: 0, count: count)
        let outcome: Result<Void, Random.Error> = result.withUnsafeMutableBytes { buffer in
            do throws(Random.Error) {
                try fill(buffer)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
        try outcome.get()
        return result
    }
}

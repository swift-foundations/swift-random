extension Random {

    public static func bytes(count: Int) throws(Random.Error) -> [UInt8] {
        guard count > 0 else { return [] }
        var result = [UInt8](repeating: 0, count: count)
        let outcome: Result<Void, Random.Error> = result.withUnsafeMutableBytes { buffer in
            do throws(Random.Error) {
                try unsafe fill(buffer)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
        try outcome.get()
        return result
    }
}

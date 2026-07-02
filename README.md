# swift-random

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Cryptographically-secure random bytes from the operating system's CSPRNG, behind one cross-platform Swift API.

One `import Random` replaces the platform branching — `arc4random_buf` on Darwin, `getrandom(2)` on Linux, `BCryptGenRandom` on Windows — that fetching OS entropy otherwise requires, and surfaces every failure as a typed `Random.Error` instead of a silent partial fill or an untyped throw.

## Quick Start

```swift
import Random

// 256-bit key material straight from the OS CSPRNG
let key = try Random.bytes(count: 32)

// Fill an existing buffer without allocating
var nonce = [UInt8](repeating: 0, count: 12)
try nonce.withUnsafeMutableBytes { buffer in
    try Random.fill(buffer)
}
```

Both calls throw `Random.Error` — never `any Error` — so exhaustive handling is a two-arm `catch`:

```swift
do {
    let seed = try Random.bytes(count: 16)
} catch .entropyNotReady {
    // Linux only: getrandom(2) before the boot-time entropy pool initializes
} catch .systemError(let code) {
    // Platform error code: errno (POSIX) or NTSTATUS (Windows)
}
```

## Installation

Add swift-random to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-random.git", branch: "main")
]
```

Add to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Random", package: "swift-random")
    ]
)
```

### Requirements

- Swift 6.3+
- macOS 26.0+, iOS 26.0+, tvOS 26.0+, watchOS 26.0+, visionOS 26.0+ (for Apple platforms)

## Key Features

- **Cross-platform CSPRNG** — `arc4random_buf` (Darwin), `getrandom(2)` (Linux), `BCryptGenRandom` (Windows) behind a single `Random.fill(_:)` call; the platform backend is selected at compile time.
- **Typed throws end-to-end** — every throwing API throws `Random.Error`; no `any Error` escapes the surface.
- **Allocation-free path** — `Random.fill(_:)` writes into a caller-owned buffer; `Random.bytes(count:)` is the allocating convenience.
- **Testable generation** — the `Random.Generator` protocol lets tests inject deterministic generators in place of the OS CSPRNG.
- **No Foundation import** — the package depends only on its ecosystem primitives and platform kernels.

## API Surface

swift-random is an umbrella over `Random Primitives` plus the platform kernel that provides `fill(_:)` for the compilation target. Importing `Random` gives you the whole surface:

| Symbol | Role |
|--------|------|
| `Random.fill(_: UnsafeMutableRawBufferPointer) throws(Random.Error)` | Fills a caller-owned buffer from the OS CSPRNG (platform-provided) |
| `Random.bytes(count:) throws(Random.Error) -> [UInt8]` | Allocating convenience over `fill(_:)` (this package) |
| `Random.Error` | `.entropyNotReady` \| `.systemError(Int32)` |
| `Random.Generator` | Protocol for custom / deterministic generators |

## Platform Support

| Platform | Backend | Status |
|----------|---------|--------|
| macOS / iOS / tvOS / watchOS / visionOS | `arc4random_buf` | Supported |
| Linux | `getrandom(2)` | Supported |
| Windows | `BCryptGenRandom` | Supported |

`getrandom(2)` can report `.entropyNotReady` when called before the kernel's entropy pool initializes (immediately after boot); Darwin and Windows backends do not have this failure mode.

## Related Packages

### Dependencies

- swift-random-primitives (pre-release, no tags yet) — `Random` namespace, `Random.Error`, and the `Random.Generator` protocol.
- [swift-darwin](https://github.com/swift-foundations/swift-darwin) — Darwin kernel interface providing `Random.fill(_:)` on Apple platforms.
- [swift-linux](https://github.com/swift-foundations/swift-linux) — Linux kernel interface providing `Random.fill(_:)` on Linux.
- [swift-windows](https://github.com/swift-foundations/swift-windows) — Windows kernel interface providing `Random.fill(_:)` on Windows.

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public flip.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).

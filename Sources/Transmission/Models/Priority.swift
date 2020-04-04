/// A priority value for Transmission downloads.
public struct Priority: RawRepresentable, Equatable, Hashable {
    public typealias RawValue = Int

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension Priority {
    /// The low priority value. This has a `rawValue` of `-1`.
    static let low = Priority(rawValue: -1)
    /// The normal priority value. This has a `rawValue` of `0`.
    static let normal = Priority(rawValue: 0)
    /// The high priority value. This has a `rawValue` of `1`.
    static let high = Priority(rawValue: 1)
}

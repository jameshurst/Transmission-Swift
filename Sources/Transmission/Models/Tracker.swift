/// A Transmission tracker.
public struct Tracker: Equatable {
    /// The tracker's ID.
    public let id: Int
    /// The tracker host URL.
    public let host: String

    /// Initializes a tracker.
    public init(id: Int, host: String) {
        self.id = id
        self.host = host
    }
}

extension Tracker {
    /// Initializes a tracker using a response dictionary, returning nil if any required properties are missing.
    /// - Parameter dictionary: The response dictionary for the tracker.
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let host = dictionary["host"] as? String
        else {
            return nil
        }

        self.id = id
        self.host = host
    }
}

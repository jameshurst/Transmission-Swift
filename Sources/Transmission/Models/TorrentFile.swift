/// A Transmission torrent file.
public struct TorrentFile: Equatable {
    /// The index of the file.
    public var index: Int
    /// The name of the file.
    public var name: String
    /// The size of the file in bytes.
    public var size: Int64
    /// The number of bytes that have been downloaded.
    public var downloaded: Int64
    /// The download priority of the file.
    public var priority: Priority
    /// Whether the file is marked as wanted or unwanted.
    public var isWanted: Bool

    /// Initializes a torrent file.
    public init(index: Int, name: String, size: Int64, downloaded: Int64, priority: Priority, isWanted: Bool) {
        self.index = index
        self.name = name
        self.size = size
        self.downloaded = downloaded
        self.priority = priority
        self.isWanted = isWanted
    }
}

extension TorrentFile {
    /// Initializes a torrent file using response dictionaries, returning nil if any required properties are missing.
    /// - Parameters:
    ///   - index: The index of the file.
    ///   - file: The file information dictionary.
    ///   - stats: The file stats dictionary.
    init?(index: Int, file: [String: Any], stats: [String: Any]) {
        guard let name = file["name"] as? String,
              let size = file["length"] as? Int64,
              let downloaded = file["bytesCompleted"] as? Int64,
              let priority = stats["priority"] as? Int,
              let isWanted = stats["wanted"] as? Bool
        else {
            return nil
        }

        self.index = index
        self.name = name
        self.size = size
        self.downloaded = downloaded
        self.priority = Priority(rawValue: priority)
        self.isWanted = isWanted
    }
}

/// An option that can be set on a torrent.
public struct TorrentOption {
    /// The key identifying the option.
    ///
    /// Refer to the
    /// [RPC spec](https://git.deluge-torrent.org/deluge/tree/deluge/core/torrent.py) for valid keys.
    public var key: String
    /// The value of the option.
    public var value: Any
}

public extension TorrentOption {
    /// Marks the files with the given indices as wanted.
    ///
    /// Key: `files-wanted`
    ///
    /// - Parameter indices: The file indices to update.
    static func filesWanted(indices: [Int]) -> Self {
        .init(key: "files-wanted", value: indices)
    }

    /// Marks the files with the given indices as unwanted.
    ///
    /// Key: `files-unwanted`
    ///
    /// - Parameter indices: The file indices to update.
    static func filesUnwanted(indices: [Int]) -> Self {
        .init(key: "files-unwanted", value: indices)
    }

    /// Sets the priority to low for files with the given indices.
    ///
    /// Key: `priority-low`
    ///
    /// - Parameter indices: The file indices to update.
    static func priorityLow(indices: [Int]) -> Self {
        .init(key: "priority-low", value: indices)
    }

    /// Sets the priority to normal for files with the given indices.
    ///
    /// Key: `priority-normal`
    ///
    /// - Parameter indices: The file indices to update.
    static func priorityNormal(indices: [Int]) -> Self {
        .init(key: "priority-normal", value: indices)
    }

    /// Sets the priority to high for files with the given indices.
    ///
    /// Key: `priority-high`
    ///
    /// - Parameter indices: The file indices to update.
    static func priorityHigh(indices: [Int]) -> Self {
        .init(key: "priority-high", value: indices)
    }
}

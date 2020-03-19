import Foundation

public extension Request {
    // MARK: Action Requests

    /// Starts torrents with the given IDs and/or hashes.
    ///
    /// RPC Method: `torrent-start`
    ///
    /// - Parameter ids: The torrent IDs and/or hashes to start.
    static func start(ids: [Any]) -> Request<Void> {
        .init(method: "torrent-start", args: ["ids": ids])
    }

    /// Stops torrents with the given IDs and/or hashes.
    ///
    /// RPC Method: `torrent-stop`
    ///
    /// - Parameter ids: The torrent IDs and/or hashes to stop.
    static func stop(ids: [Any]) -> Request<Void> {
        .init(method: "torrent-stop", args: ["ids": ids])
    }

    /// Verifies the data for torrents with the given IDs and/or hashes.
    ///
    /// RPC Method: `torrent-verify`
    ///
    /// - Parameter ids: The torrent IDs and/or hashes to verify.
    static func verify(ids: [Any]) -> Request<Void> {
        .init(method: "torrent-verify", args: ["ids": ids])
    }

    /// Forces a reannounce for torrents with the given IDs and/or hashes.
    ///
    /// RPC Method: `torrent-reannounce`
    ///
    /// - Parameter ids: The torrent IDs and/or hashes to reannounce.
    static func reannounce(ids: [Any]) -> Request<Void> {
        .init(method: "torrent-reannounce", args: ["ids": ids])
    }

    // MARK: Get Requests

    /// Requests the list of torrents.
    ///
    /// RPC Method: `torrent-get`
    ///
    /// Result: The list of torrents.
    ///
    /// - Parameter properties: The torrent properties to include.
    static func torrents(properties: [Torrent.PropertyKeys]) -> Request<[Torrent]> {
        .init(
            method: "torrent-get",
            args: ["fields": properties.map { $0.rawValue }],
            transform: { response in
                guard let arguments = response["arguments"] as? [String: Any],
                    let torrents = arguments["torrents"] as? [[String: Any]]
                else {
                    return .failure(.unexpectedResponse)
                }

                return .success(torrents.compactMap(Torrent.init))
            }
        )
    }

    /// Requests the list of files for a torrents.
    ///
    /// RPC Method: `torrent-get`
    ///
    /// Result: The list of files for the torrent.
    ///
    /// - Parameter ids: The torrent ID or hash whose files should be requested.
    static func torrentFiles(id: Any) -> Request<[TorrentFile]> {
        .init(
            method: "torrent-get",
            args: ["ids": [id], "fields": ["files", "fileStats"]],
            transform: { response -> Result<[TorrentFile], TransmissionError> in
                guard let arguments = response["arguments"] as? [String: Any],
                    let torrents = arguments["torrents"] as? [[String: Any]],
                    !torrents.isEmpty,
                    let filesDict = torrents[0]["files"] as? [[String: Any]],
                    let statsDict = torrents[0]["fileStats"] as? [[String: Any]]
                else {
                    return .failure(.unexpectedResponse)
                }

                return .success(zip(filesDict, statsDict).enumerated().compactMap { index, element in
                    TorrentFile(index: index, file: element.0, stats: element.1)
                })
            }
        )
    }

    // MARK: Add Requests

    /// Adds a torrent using a web URL to a torrent file or a magnet URL.
    ///
    /// RPC Method: `torrent-add`
    ///
    /// - Parameter url: The web or magnet URL of the torrent to add.
    static func add(url: URL) -> Request<Void> {
        .init(method: "torrent-add", args: ["filename": url.absoluteString])
    }

    /// Adds a torrent using a URL to a local torrent file.
    ///
    /// RPC Method: `torrent-add`
    ///
    /// - Parameter fileURL: The URL of the local torrent file to add.
    static func add(fileURL: URL) -> Request<Void> {
        let data = FileManager.default.contents(atPath: fileURL.path)?.base64EncodedString() ?? ""
        return .init(method: "torrent-add", args: ["metainfo": data])
    }

    // MARK: Remove Requests

    /// Removes torrents with the given IDs and/or hashes.
    ///
    /// RPC Method: `torrent-remove`
    ///
    /// - Parameters:
    ///   - ids: The torrent IDs and/or hashes to remove.
    ///   - removeData: Whether the torrents' data should be removed.
    static func remove(ids: [Any], removeData: Bool) -> Request<Void> {
        .init(method: "torrent-remove", args: ["ids": ids, "delete-local-data": removeData])
    }

    // MARK: Set Location

    /// Moves the storage for torrents with the given IDs and/or hashes.
    ///
    /// RPC Method: `torrent-set-location`
    ///
    /// - Parameters:
    ///   - ids: The torrent IDs and/or hashes whose storage should be moved.
    ///   - path: The new path where the torrents' data should be stored.
    static func move(ids: [Any], path: String) -> Request<Void> {
        .init(method: "torrent-set-location", args: ["ids": ids, "location": path, "move": true])
    }
}

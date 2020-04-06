import Foundation

/// A Transmission torrent.
public struct Torrent: Equatable {
    /// The number of bytes of partial pieces.
    public var bytesUnchecked: Int64?
    /// The number of bytes of checksum verified data.
    public var bytesValid: Int64?
    /// The date the torrent was added to the server.
    public var dateAdded: Date?
    /// The file path where the torrent data is being downloaded to.
    public var downloadPath: String?
    /// The download rate for the torrent in bytes/s.
    public var downloadRate: Int64?
    /// The estimated number of seconds until the torrent completes downloading.
    public var eta: TimeInterval?
    /// The SHA1 hash for the torrent.
    public var hash: String?
    /// The torrent's ID.
    public var id: Int?
    /// The name of the torrent.
    public var name: String?
    /// The number of connected peers for the torrent.
    public var peers: Int?
    /// The download progress for the torrent as a percentage. This is a value between 0 and 1.
    public var progress: Float?
    /// The number of connected seeds for the torrent.
    public var seeds: Int?
    /// The size of the torrent contents in bytes.
    public var size: Int64?
    /// The status of the torrent.
    public var status: Status?
    /// The number of available peers for the torrent.
    public var totalPeers: Int?
    /// The trackers used by the torrent.
    public var trackers: [Tracker]?
    /// The number of bytes uploaded for the torrent.
    public var uploaded: Int64?
    /// The upload rate for the torrent in bytes/s.
    public var uploadRate: Int64?

    /// Initializes a torrent.
    public init(
        bytesUnchecked: Int64? = nil,
        bytesValid: Int64? = nil,
        dateAdded: Date? = nil,
        downloadPath: String? = nil,
        downloadRate: Int64? = nil,
        eta: TimeInterval? = nil,
        hash: String? = nil,
        id: Int? = nil,
        name: String? = nil,
        peers: Int? = nil,
        progress: Float? = nil,
        seeds: Int? = nil,
        size: Int64? = nil,
        status: Torrent.Status? = nil,
        totalPeers: Int? = nil,
        trackers: [Tracker]? = nil,
        uploaded: Int64? = nil,
        uploadRate: Int64? = nil
    ) {
        self.bytesUnchecked = bytesUnchecked
        self.bytesValid = bytesValid
        self.dateAdded = dateAdded
        self.downloadPath = downloadPath
        self.downloadRate = downloadRate
        self.eta = eta
        self.hash = hash
        self.id = id
        self.name = name
        self.peers = peers
        self.progress = progress
        self.seeds = seeds
        self.size = size
        self.status = status
        self.totalPeers = totalPeers
        self.trackers = trackers
        self.uploaded = uploaded
        self.uploadRate = uploadRate
    }
}

public extension Torrent {
    /// The status of a torrent.
    enum Status: Int {
        /// The torrent is paused.
        case paused = 0
        /// The torrent is queued to be verified.
        case checkQueued = 1
        /// The torrent data is being verified.
        case checking = 2
        /// The torrent is queued to be downloaded.
        case downloadQueued = 3
        /// The torrent is downloading.
        case downloading = 4
        /// The torrent is queued to be seeded.
        case seedQueued = 5
        /// The torrent is seeding.
        case seeding = 6
        /// The torrent is isolated.
        case isolated = 7
    }
}

public extension Torrent {
    /// The keys used to request torrent properties.
    enum PropertyKeys: String, CaseIterable {
        /// Requests the key `haveUnchecked` from the API.
        case bytesUnchecked = "haveUnchecked"
        /// Requests the key `haveValid` from the API.
        case bytesValid = "haveValid"
        /// Requests the key `addedDate` from the API.
        case dateAdded = "addedDate"
        /// Requests the key `downloadDir` from the API.
        case downloadPath = "downloadDir"
        /// Requests the key `rateDownload` from the API.
        case downloadRate = "rateDownload"
        /// Requests the key `eta` from the API.
        case eta
        /// Requests the key `hashString` from the API.
        case hash = "hashString"
        /// Requests the key `id` from the API.
        case id
        /// Requests the key `name` from the API.
        case name
        /// Requests the key `peersGettingFromUs` from the API.
        case peers = "peersGettingFromUs"
        /// Requests the key `percentDone` from the API.
        case progress = "percentDone"
        /// Requests the key `peersSendingToUs` from the API.
        case seeds = "peersSendingToUs"
        /// Requests the key `totalSize` from the API.
        case size = "totalSize"
        /// Requests the key `status` from the API.
        case status
        /// Requests the key `peersConnected` from the API.
        case totalPeers = "peersConnected"
        /// Requests the key `trackerStats` from the API.
        case trackers = "trackerStats"
        /// Requests the key `uploadedEver` from the API.
        case uploaded = "uploadedEver"
        /// Requests the key `rateUpload` from the API.
        case uploadRate = "rateUpload"
    }
}

extension Torrent {
    /// Initializes a torrent using a response dictionary.
    /// - Parameter dictionary: The response dictionary for the torrent.
    init(dictionary: [String: Any]) {
        func decode<Value>(_ propertyKey: PropertyKeys, _ type: Value.Type? = nil) -> Value? {
            dictionary[propertyKey.rawValue] as? Value
        }

        bytesUnchecked = decode(.bytesUnchecked)
        bytesValid = decode(.bytesValid)
        dateAdded = decode(.dateAdded).map(Date.init(timeIntervalSince1970:))
        downloadPath = decode(.downloadPath)
        downloadRate = decode(.downloadRate)
        eta = decode(.eta)
        hash = decode(.hash)
        id = decode(.id)
        name = decode(.name)
        peers = decode(.peers)
        progress = decode(.progress, Double.self).map(Float.init)
        seeds = decode(.seeds)
        size = decode(.size)
        status = decode(.status).flatMap(Status.init)
        totalPeers = decode(.totalPeers)
        trackers = decode(.trackers, [[String: Any]].self).flatMap { $0.compactMap(Tracker.init) }
        uploaded = decode(.uploaded)
        uploadRate = decode(.uploadRate)
    }
}

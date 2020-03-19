import Foundation
import Transmission

enum TestConfig {
    static let serverURL = URL(string: "http://localhost:9091")!
    static let serverUsername: String? = nil
    static let serverPassword: String? = nil
    static let torrent1Resource = "debian.torrent"
    static let torrent1Hash = "5a8062c076fa85e8056451c0d9aa04349ae27909"
    static let torrent1Trackers = [Tracker(id: 0, host: "http://bttracker.debian.org:6969")]
    static let torrent1FileName = "debian-10.3.0-amd64-netinst.iso"
    static let torrent2Resource = "mint.torrent"
    static let torrent2Hash = "2a78414b7af89fe08644ece339ee454867d29cb7"
    // swiftformat:disable indent
    static let magnetURL = """
            magnet:?xt=urn:btih:54da0b79719064aa10fe2cc4e13630a1222d1939&dn=archlinux-2020.03.01-x86_64.iso\
            &tr=udp://tracker.archlinux.org:6969&tr=http://tracker.archlinux.org:6969/announce
            """
    // swiftformat:enable indent
    static let webURL = "https://downloads.raspberrypi.org/raspbian_latest.torrent"
}

import Combine
import Transmission
import XCTest

class TorrentGetRequestsTests: XCTestCase {
    private var client: Transmission!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        client = Transmission(
            baseURL: TestConfig.serverURL,
            username: TestConfig.serverUsername,
            password: TestConfig.serverPassword
        )
        cancellables = Set()
    }

    func test_torrents() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.torrents(properties: Torrent.PropertyKeys.allCases)) }
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { torrents in
                    let torrent = torrents.first { $0.hash == TestConfig.torrent1Hash }
                    XCTAssertNotNil(torrent?.id)
                    XCTAssertNotNil(torrent?.dateAdded)
                    XCTAssertNotNil(torrent?.downloadPath)
                    XCTAssertNotNil(torrent?.downloadRate)
                    XCTAssertNotNil(torrent?.eta)
                    XCTAssertNotNil(torrent?.hash)
                    XCTAssertNotNil(torrent?.peers)
                    XCTAssertNotNil(torrent?.progress)
                    XCTAssertNotNil(torrent?.seeds)
                    XCTAssertNotNil(torrent?.size)
                    XCTAssertNotNil(torrent?.status)
                    XCTAssertNotNil(torrent?.totalPeers)
                    XCTAssertNotNil(torrent?.trackers)
                    XCTAssertEqual(torrent?.trackers, TestConfig.torrent1Trackers)
                    XCTAssertNotNil(torrent?.uploaded)
                    XCTAssertNotNil(torrent?.uploadRate)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }

    func test_torrentFiles() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.torrentFiles(id: TestConfig.torrent1Hash)) }
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { files in
                    XCTAssertEqual(files.count, 1)
                    XCTAssertEqual(files.first?.name, TestConfig.torrent1FileName)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }
}

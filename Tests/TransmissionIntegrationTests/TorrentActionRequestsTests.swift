import Combine
import Transmission
import XCTest

class TorrentActionRequestsTests: XCTestCase {
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

    func test_start() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.start(ids: [TestConfig.torrent1Hash])) }
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }

    func test_stop() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.stop(ids: [TestConfig.torrent1Hash])) }
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }

    func test_verify() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.verify(ids: [TestConfig.torrent1Hash])) }
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }

    func test_reannounce() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.reannounce(ids: [TestConfig.torrent1Hash])) }
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }
}

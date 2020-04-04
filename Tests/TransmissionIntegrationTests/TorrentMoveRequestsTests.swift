import Combine
import Transmission
import XCTest

class TorrentMoveRequestsTests: IntegrationTestCase {
    func test_start() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap { _ in self.client.request(.move(ids: [TestConfig.torrent1Hash], path: "/tmp")) }
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
        waitForExpectations(timeout: TestConfig.timeout)
    }
}

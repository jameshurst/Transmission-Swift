import Combine
import Transmission
import XCTest

class TorrentSetRequestsTests: IntegrationTestCase {
    func test_filesWanted() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap {
                self.client.request(.setOptions(
                    ids: [TestConfig.torrent1Hash],
                    options: [.filesWanted(indices: [0])]
                ))
            }
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

    func test_filesUnwanted() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap {
                self.client.request(.setOptions(
                    ids: [TestConfig.torrent1Hash],
                    options: [.filesUnwanted(indices: [0])]
                ))
            }
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

    func test_priorityLow() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap {
                self.client.request(.setOptions(
                    ids: [TestConfig.torrent1Hash],
                    options: [.priorityLow(indices: [0])]
                ))
            }
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

    func test_priorityNormal() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap {
                self.client.request(.setOptions(
                    ids: [TestConfig.torrent1Hash],
                    options: [.priorityNormal(indices: [0])]
                ))
            }
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

    func test_priorityHigh() {
        let url = urlForResource(named: TestConfig.torrent1Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        ensureTorrentAdded(fileURL: url, to: client)
            .flatMap {
                self.client.request(.setOptions(
                    ids: [TestConfig.torrent1Hash],
                    options: [.priorityHigh(indices: [0])]
                ))
            }
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

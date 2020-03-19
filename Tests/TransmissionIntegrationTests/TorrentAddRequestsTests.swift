import Combine
import Transmission
import XCTest

class TorrentAddRequestsTests: XCTestCase {
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

    func test_addFileURL() {
        let url = urlForResource(named: TestConfig.torrent2Resource)
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        client.request(.add(fileURL: url))
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

    func test_addMagnetURL() {
        let url = URL(string: TestConfig.magnetURL)!
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        client.request(.add(url: url))
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

    func test_addURL() {
        let url = URL(string: TestConfig.webURL)!
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        client.request(.add(url: url))
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
        waitForExpectations(timeout: 2)
    }
}

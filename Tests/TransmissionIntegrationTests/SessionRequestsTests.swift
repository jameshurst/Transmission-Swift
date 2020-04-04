import Combine
import Transmission
import XCTest

class SessionRequestsTests: IntegrationTestCase {
    func test_rpcVersion() {
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        client.request(.rpcVersion)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail(String(describing: error))
                    }
                    expectation.fulfill()
                },
                receiveValue: { rpcVersion in
                    XCTAssertGreaterThanOrEqual(rpcVersion, 15)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: TestConfig.timeout)
    }
}

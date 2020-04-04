import Combine
import Transmission
import XCTest

class BadMethodTests: IntegrationTestCase {
    func test_badMethod() {
        let bad = Request<Void>(method: "bad", args: [:]) { response in
            XCTFail("Unexpected response: \(String(describing: response))")
            return .failure(.unexpectedResponse)
        }
        let expectation = self.expectation(description: #function)
        expectation.expectedFulfillmentCount = 1
        client.request(bad)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion, case .serverError = error {
                        // success
                    } else {
                        XCTFail("Expected failure")
                    }

                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Should not receive value")
                }
            )
            .store(in: &cancellables)
        waitForExpectations(timeout: TestConfig.timeout)
    }
}

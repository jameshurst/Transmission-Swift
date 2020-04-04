import Combine
import Transmission
import XCTest

class IntegrationTestCase: XCTestCase {
    var client: Transmission!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        client = Transmission(
            baseURL: TestConfig.serverURL,
            username: TestConfig.serverUsername,
            password: TestConfig.serverPassword
        )
        cancellables = Set()
    }
}

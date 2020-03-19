import Combine
import Foundation

/// A Transmission RPC API client.
public final class Transmission {
    private enum Headers {
        static let sessionID = "X-Transmission-Session-Id"
    }

    /// The server provided session ID.
    private var sessionID: String?

    /// The `URLSession` to use for requests.
    private lazy var session: URLSession = {
        URLSession.shared
    }()

    /// The URL of the Transmission server.
    let baseURL: URL
    /// The username used for authentication.
    let username: String?
    /// The password used for authentication.
    let password: String?

    /// Creates a Transmission client to interact with the given server URL.
    /// - Parameters:
    ///   - baseURL: The URL of the Transmission server.
    ///   - username: The username used for authentication.
    ///   - password: The password used for authentication.
    public init(baseURL: URL, username: String?, password: String?) {
        self.baseURL = baseURL
        self.username = username
        self.password = password
    }

    /// Sends a request to the server.
    /// - Parameter request: The request to be sent to the server.
    /// - Returns: A publisher that emits a value when the request completes.
    public func request<Value>(_ request: Request<Value>) -> AnyPublisher<Value, TransmissionError> {
        send(request: request, handleSessionID: true)
            .flatMap { request.transform($0).publisher.eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }

    /// Creates a `URLRequest` from a `Request`.
    /// - Parameter request: The request definition to be converted in to a `URLRequest`.
    /// - Returns: A `Result` containing either the created `URLRequest` or an `Error` if the request was unable to be
    /// serialized to JSON.
    private func urlRequest<Value>(from request: Request<Value>) -> Result<URLRequest, TransmissionError> {
        let url = baseURL.appendingPathComponent("transmission").appendingPathComponent("rpc")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if username != nil || password != nil {
            let username = self.username ?? ""
            let password = self.password ?? ""
            if let data = "\(username):\(password)".data(using: .utf8) {
                urlRequest.addValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: "Authorization")
            }
        }

        if let sessionID = sessionID {
            urlRequest.addValue(sessionID, forHTTPHeaderField: Headers.sessionID)
        }

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: [
                "method": request.method,
                "arguments": request.args,
            ], options: [])
        } catch {
            return .failure(.encoding(error))
        }

        return .success(urlRequest)
    }

    /// Sends a `URLRequest` optionally handling the session ID.
    ///
    /// - Parameters:
    ///   - request: The request to be sent to the server.
    ///   - handleSessionID: Whether the request should be retried if the server indicates that the client's session ID
    ///   is invalid.
    /// - Returns: A publisher that emits the decoded server response.
    private func send<Value>(
        request: Request<Value>, handleSessionID: Bool
    ) -> AnyPublisher<[String: Any], TransmissionError> {
        // swiftlint:disable:next line_length
        let retryIfNeeded = { (data: Data, response: URLResponse) -> AnyPublisher<(data: Data, response: URLResponse), TransmissionError> in
            guard let urlResponse = response as? HTTPURLResponse, handleSessionID else {
                return Just((data, response)).setFailureType(to: TransmissionError.self).eraseToAnyPublisher()
            }

            switch urlResponse.statusCode {
            case 200 ..< 300:
                return Just((data, response)).setFailureType(to: TransmissionError.self).eraseToAnyPublisher()
            case 401:
                return Fail(error: .unauthenticated).eraseToAnyPublisher()
            case 409:
                guard handleSessionID,
                    let sessionID = urlResponse.allHeaderFields[Headers.sessionID] as? String
                else {
                    return Fail(error: .noSessionID).eraseToAnyPublisher()
                }

                self.sessionID = sessionID
                return self.urlRequest(from: request).publisher
                    .flatMap { self.session.dataTaskPublisher(for: $0).mapError { .request($0) } }
                    .eraseToAnyPublisher()
            default:
                return Fail(error: .statusCode(urlResponse.statusCode)).eraseToAnyPublisher()
            }
        }

        return urlRequest(from: request).publisher
            .flatMap { self.session.dataTaskPublisher(for: $0).mapError { .request($0) } }
            .flatMap(retryIfNeeded)
            .flatMap(decode(data:response:))
            .eraseToAnyPublisher()
    }

    /// Attempts to decode a server response in to a dictionary.
    /// - Parameters:
    ///   - data: The data returned from the server.
    ///   - response: The `URLResponse` describing the server response.
    /// - Returns: A publisher that emits the decoded dictionary.
    private func decode(data: Data, response: URLResponse) -> AnyPublisher<[String: Any], TransmissionError> {
        let dict: [String: Any]

        do {
            guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return Fail(error: .unexpectedResponse).eraseToAnyPublisher()
            }

            dict = object
        } catch {
            return Fail(error: .decoding(error)).eraseToAnyPublisher()
        }

        guard let result = dict["result"] as? String else {
            return Fail(error: .unexpectedResponse).eraseToAnyPublisher()
        }

        switch result {
        case "success":
            return Just(dict).setFailureType(to: TransmissionError.self).eraseToAnyPublisher()
        default:
            return Fail(error: .serverError(result: result)).eraseToAnyPublisher()
        }
    }
}

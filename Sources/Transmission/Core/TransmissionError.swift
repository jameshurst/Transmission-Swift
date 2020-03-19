import Foundation

/// Errors that can occur during Transmission operations.
public enum TransmissionError: Error {
    /// An error occurred while encoding the request.
    case encoding(Error)
    /// An error occurred while decoding the response.
    case decoding(Error)
    /// A filesystem error occurred.
    case filesystem(Error)
    /// A request error occurred.
    case request(URLError)
    /// The server returned an unexpected status code.
    case statusCode(Int)
    /// Unable to obtain a Session ID.
    case noSessionID
    /// The provided authentication was not valid.
    case unauthenticated
    /// The server returned an unexpected response.
    case unexpectedResponse
    /// The server returned an error result.
    case serverError(result: String?)
}

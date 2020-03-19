import Combine

/// A definition for a Transmission RPC request.
public struct Request<Value> {
    /// The RPC method.
    public var method: String
    /// The arguments passed to the RPC method.
    public var args: [String: Any]
    /// Transforms the server response in to a new representation.
    public var transform: ([String: Any]) -> Result<Value, TransmissionError>

    /// Creates a request.
    /// - Parameters:
    ///   - method: The RPC method.
    ///   - args: The arguments passed to the RPC method.
    ///   - transform: Transforms the server response in to a new representation.
    public init(
        method: String,
        args: [String: Any],
        transform: @escaping ([String: Any]) -> Result<Value, TransmissionError>
    ) {
        self.method = method
        self.args = args
        self.transform = transform
    }
}

public extension Request where Value == Void {
    /// A convenience initializer for `Void` transforms. This provides a default transform implementation that simply
    /// returns a `Void` value.
    /// - Parameters:
    ///   - method: The RPC method.
    ///   - args: The arguments passed to the RPC method.
    init(method: String, args: [String: Any]) {
        self.init(method: method, args: args, transform: { _ in .success(()) })
    }
}

public extension Request {
    /// Creates a new request by mapping the `Value` of the request in to a new representation.
    /// - Parameter transform: Transforms the value in to a new representation.
    /// - Returns: The mapped request.
    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> Request<NewValue> {
        let original = self
        return Request<NewValue>(
            method: method,
            args: args,
            transform: { original.transform($0).map(transform) }
        )
    }
}

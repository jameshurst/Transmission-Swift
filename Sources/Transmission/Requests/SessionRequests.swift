public extension Request {
    // MARK: Get Requests

    /// Requests the RPC API version of the Transmission server.
    ///
    /// RPC Method: `session-get`
    ///
    /// Result: The RPC API version.
    static var rpcVersion: Request<Int> {
        .init(
            method: "session-get",
            args: ["fields": ["rpc-version"]],
            transform: { response -> Result<Int, TransmissionError> in
                guard let arguments = response["arguments"] as? [String: Any],
                    let version = arguments["rpc-version"] as? Int
                else {
                    return .failure(.unexpectedResponse)
                }

                return .success(version)
            }
        )
    }
}

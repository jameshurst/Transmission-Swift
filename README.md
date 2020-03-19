# Transmission

A Combine powered Transmission RPC API client.

## Usage

```swift
import Combine
import Transmission

var cancellables = Set<AnyCancellable>()

let client = Transmission(baseURL: URL(string: "https://my.torrent.server")!, username: nil, password: nil)
client.request(.rpcVersion)
    .sink(receiveCompletion: { _ in }, receiveValue: { rpcVersion in
        print("RPC Version: \(rpcVersion)")
    })
    .store(in: &cancellables)
```

## Requests

A `Request` describes an RPC method, its arguments, and a function to transform the API response in to a new representation.

There are many requests already built-in. To see the available requests you can can take a look at the [Requests](Sources/Transmission/Requests/) directory or browse through the autocomplete menu when typing `client.request(.`.

```swift
let rpcVersion = Request<Int>(
    method: "session-get",
    args: ["fields": ["rpc-version"]],
    transform: { response in
        guard let arguments = response["arguments"] as? [String: Any],
                let version = arguments["rpc-version"] as? Int
        else {
            return .failure(.unexpectedResponse)
        }

        return .success(version)
    }
)
```

## Installation

### Xcode 11+

* Select **File** > **Swift Packages** > **Add Package Dependency...**
* Enter the package repository URL: `https://github.com/jameshurst/Transmission-Swift.git`
* Confirm the version and let Xcode resolve the package

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

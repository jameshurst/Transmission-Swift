import Combine
import Foundation
import Transmission

func urlForResource(named resourceName: String) -> URL {
    URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources", isDirectory: true)
        .appendingPathComponent(resourceName)
}

func ensureTorrentAdded(fileURL: URL, to client: Transmission) -> AnyPublisher<Void, TransmissionError> {
    client.request(.add(fileURL: fileURL))
        .map { _ in () }
        .replaceError(with: ())
        .setFailureType(to: TransmissionError.self)
        .eraseToAnyPublisher()
}

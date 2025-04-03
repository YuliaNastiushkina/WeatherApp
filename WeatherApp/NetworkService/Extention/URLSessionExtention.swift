import Foundation

extension URLSession: RequestProtocol {
    /// Fetches data from the given URL asynchronously.
    /// This method conforms `URLSession` to `RequestProtocol`, allowing it to be used as a network service for making API requests.
    /// - Parameter url: The URL from which to fetch data.
    /// - Returns: A tuple containing the raw `Data` and the `URLResponse` received from the server.
    /// - Throws: An error if the network request fails.
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
    }
}

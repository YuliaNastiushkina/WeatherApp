import Foundation

/// Responsible for handling weather data requests from the OpenWeatherMap API
struct Request {
    
    /// Fetches weather data for a specified city.
    /// - Parameter city: The name of the city for which to fetch weather data.
    /// - Returns: A `WeatherModel` object containing weather details for the specified city.
    /// - Throws:
    ///     - `NSError` if the API key is missing.
    ///     - `URLError` if the constructed URL is invalid.
    ///     - An error from `URLSession` or `JSONDecoder` during the network request or decoding.
    ///     - `URLError(.badServerResponse)` if:
    ///         - The server response cannot be cast to `HTTPURLResponse`.
    ///         - The HTTP status code of the response is outside the range 200–299.
    func getWeather(for city: String) async throws -> WeatherModel {
        guard let apiKey = getAPIKey() else {
            throw NSError(domain: "WeatherApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "API Key is missing"])
        }
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        return try await fetchAndDecode(urlString: urlString)
    }
    
    /// Fetches city name suggestions based on a search query
    /// - Parameter query: A string containing the search query to find cities.
    /// - Returns: An array of `CitySuggestion` objects containing city names and their respective countries.
    /// - Throws:
    ///     - `NSError` if the API key is missing.
    ///     - `URLError` if there is an issue with the URL construction or fetching data.
    ///     - `URLError(.badServerResponse)` if the server response is invalid.
    func searchCities(query: String) async throws -> [CitySuggestion] {
        guard let apiKey = getAPIKey() else {
            throw NSError(domain: "WeatherApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "API Key is missing"])
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedQuery)&limit=5&appid=\(apiKey)"
        
        return try await fetchAndDecode(urlString: urlString)
    }
    
    //MARK: Private interface
    private let networkService: RequestProtocol
    
    init(networkService: RequestProtocol) {
        self.networkService = networkService
    }
    
    /// Retrieves the API key from the `Config.plist` file.
    /// - Returns: A string containing the API key, or `nil` if the key is missing or the file cannot be read.
    private func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let apiKey = dictionary["APIKey"] as? String {
            return apiKey
        }
        return nil
    }

    /// Fetches data from the provided URL and decodes the response into a specified model.
    /// - Parameter urlString: A string containing the URL to fetch data from.
    /// - Returns: A  decoded object of type `T` where `T` is a `Decodable` model.
    /// - Throws:
    ///     - `URLError(.badURL)` if the URL is invalid.
    ///     - `URLError(.badServerResponse)` if the server response is invalid.
    ///     - Any error thrown during data fetching or decoding.
    private func fetchAndDecode<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await networkService.fetchData(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}

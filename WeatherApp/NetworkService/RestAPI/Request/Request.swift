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
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await networkService.fetchData(from: url)
    
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
        
        return weather
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
}

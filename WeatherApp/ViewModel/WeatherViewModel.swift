import Foundation

/// Responsible for fetching and managing weather data.
@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var humidity: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var feelsLike: String = ""
    
    /// Fetches weather data for the specified city.
    ///
    /// - If `cityName` is empty, sets `errorMessage` to `"Please enter a city name"` and exits.
    /// - Updates `isLoading` to `true` while fetching data.
    /// - On success:
    ///     - Updates `temperature`, `feelsLike`, `description`, and `humidity` with formatted data.
    /// - On failure:
    ///     - Sets `errorMessage` to `"Failed to fetch weather data"`.
    /// - Finally, sets `isLoading` to `false` when the request is complete.
    func fetchWeather() async {
        guard !cityName.isEmpty else {
            errorMessage = "Please enter a city name"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.getWeather(for: cityName)
            temperature = "\(Int(weather.main.temp))°C"
            feelsLike = "Feels like: \(Int(weather.main.feelsLike))°C"
            description = weather.weather.first?.description.capitalized ?? "No description"
            humidity = "Humidity: \(weather.main.humidity)%"
        } catch {
            errorMessage = "Failed to fetch weather data"
        }
        
        isLoading = false
    }
    
    //MARK: Private interface
    private let weatherService: Request
    
    init(networkService: RequestProtocol) {
        self.weatherService = Request(networkService: networkService)
    }
}

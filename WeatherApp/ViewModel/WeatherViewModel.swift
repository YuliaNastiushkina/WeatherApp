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
    @Published var citySuggestions: [String] = []
    @Published var shouldShowWeather: Bool = false
    
    /// Indicates whether the weather data has been received and is ready to display.
    /// Returns `true` if all required fields are non-empty.
    var hasWeatherData: Bool {
        !temperature.isEmpty &&
        !feelsLike.isEmpty &&
        !description.isEmpty &&
        !humidity.isEmpty
    }
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
        shouldShowWeather = true
        isLoading = false
    }
    //TODO: add doc comments
    func searchCities() async {
        guard cityName.count >= 2 else {
            citySuggestions = []
            return
        }
        
        do {
            let result = try await weatherService.searchCities(query: cityName)
            print("Received cities: \(result)")
            
            citySuggestions = result
                .filter { $0.name.lowercased().hasPrefix(cityName.lowercased()) && $0.name.count > 2 }
                .map{ "\($0.name), \($0.country)" }
            
            citySuggestions = Array(Set(citySuggestions))
            print("Filtered suggestions: \(citySuggestions)")
        } catch {
            citySuggestions = []
        }
    }
    
    //MARK: Private interface
    private let weatherService: Request
    
    init(networkService: RequestProtocol) {
        self.weatherService = Request(networkService: networkService)
    }
}

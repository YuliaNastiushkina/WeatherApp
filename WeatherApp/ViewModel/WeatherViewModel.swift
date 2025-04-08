import Foundation
import SwiftData

/// Responsible for managing the weather data, including fetching and displaying weather information for a specified city.
@MainActor
class WeatherViewModel: ObservableObject, WeatherDataProtocol {
    //MARK: Private interface
    private let weatherService: Request?
    
    //MARK: Internal interface
    @Published var cityName: String = ""
    @Published var temperature: String = ""
    @Published var weatherDescription: String = ""
    @Published var feelsLike: String = ""
    @Published var humidity: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var citySuggestions: [String] = []
    @Published var shouldShowWeather: Bool = false
    
    /// Initializes the view model with a network service for fetching weather data.
    /// - Parameter networkService: A service used to make network requests for weather data.
    init(networkService: RequestProtocol) {
        self.weatherService = Request(networkService: networkService)
    }
    
    /// Initializes the view model with a saved weather object.
    /// - Parameter weather: A `SavedWeathersModel` containing weather data to display.
    init(weather: SavedWeathersModel) {
        self.weatherService = nil
        self.cityName = weather.city
        self.temperature = weather.temperature
        self.weatherDescription = weather.weatherDescription
        self.feelsLike = weather.feelsLike
        self.humidity = weather.humidity
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
        
        guard let weatherService = weatherService else {
            errorMessage = "Weather service is unavailable"
            isLoading = false
            return
        }
        
        do {
            let weather = try await weatherService.getWeather(for: cityName)
            temperature = "\(Int(weather.main.temp))°C"
            feelsLike = "Feels like: \(Int(weather.main.feelsLike))°C"
            weatherDescription = weather.weather.first?.description.capitalized ?? "No description"
            humidity = "Humidity: \(weather.main.humidity)%"
            shouldShowWeather = true
        } catch {
            errorMessage = "Failed to fetch weather data"
        }
        isLoading = false
    }
    
    /// Fetches city suggestions based on the input `cityName`.
    ///
    /// - If `cityName` has fewer than 2 characters, clears the city suggestions.
    /// - Uses the `weatherService` to search for cities matching the input.
    /// - Updates `citySuggestions` with the filtered and formatted list of city names.
    /// - On failure, sets `citySuggestions` to an empty list.
    func searchCities() async { //TODO: Implement search for city with more than 1 word
        guard cityName.count >= 2 else {
            citySuggestions = []
            return
        }
        
        guard let weatherService = weatherService else {
            errorMessage = "Weather service is unavailable"
            isLoading = false
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
}

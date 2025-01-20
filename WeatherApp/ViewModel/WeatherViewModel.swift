import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var humidity: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var feelsLike: String = ""
    
    private let weatherService = Request()
    
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
}

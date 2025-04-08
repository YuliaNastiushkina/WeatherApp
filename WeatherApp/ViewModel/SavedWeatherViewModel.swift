import Foundation
import SwiftData

/// Manages the saved weather data, allowing users to save and delete weather records.
@MainActor
class SavedWeatherViewModel: ObservableObject, WeatherDataProtocol {
    @Published var savedWeathers: [SavedWeathersModel] = []
    var modelContext: ModelContext
    
    /// Initializes the view model with a model context to manage saved weather data.
    /// - Parameter modelContext: The `ModelContext` used to interact with the underlying data store.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @Published var cityName: String = ""
    @Published var temperature: String = ""
    @Published var weatherDescription: String = ""
    @Published var feelsLike: String = ""
    @Published var humidity: String = ""
    
    /// Initializes the view model with saved weather data and a model context.
    /// - Parameters:
    ///   - savedWeather: A `SavedWeathersModel` containing weather data to display.
    ///   - modelContext: The `ModelContext` used to interact with the underlying data store.
    init(savedWeather: SavedWeathersModel, modelContext: ModelContext) {
        self.modelContext = modelContext
        self.cityName = savedWeather.city
        self.temperature = savedWeather.temperature
        self.weatherDescription = savedWeather.weatherDescription
        self.feelsLike = savedWeather.feelsLike
        self.humidity = savedWeather.humidity
    }
    
    /// Saves the specified weather data to the model context and updates the saved weather list.
    /// - Parameter data: The `SavedWeathersModel` containing the weather data to save.
    /// - Throws: Any error that occurs during the save operation will be caught and printed.
    func saveWeather(_ data: SavedWeathersModel) {
        modelContext.insert(data)
        
        do {
            try modelContext.save()
            savedWeathers.append(data)
        } catch {
            print("Failed to save weather data: \(error)")
        }
    }
    
    /// Deletes the specified weather data from the model context and updates the saved weather list.
    /// - Parameter data: The `SavedWeathersModel` containing the weather data to delete.
    /// - Throws: Any error that occurs during the delete operation will be caught and printed.
    func deleteWeather(_ data: SavedWeathersModel) {
        modelContext.delete(data)
        
        do {
            try modelContext.save()
            savedWeathers.removeAll { $0.id == data.id }
        } catch {
            print("Failed to delete weather data: \(error)")
        }
    }
}

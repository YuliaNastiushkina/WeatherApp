import SwiftUI
import SwiftData

struct SavedWeathersView: View {
    @Query var weatherData: [SavedWeathersModel]
    @StateObject var viewModel: SavedWeatherViewModel
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            ForEach(weatherData, id: \.id) { savedWeather in
                WeatherRowView(viewModel: savedWeather)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let item = weatherData[index]
                    viewModel.deleteWeather(item)
                }
            }
        }
    }
}

#Preview {
    SavedWeathersView(
        viewModel: SavedWeatherViewModel(modelContext: try! ModelContext(ModelContainer(for: SavedWeathersModel.self)))
    )
    .modelContainer(
        try! ModelContainer(for: SavedWeathersModel.self)
    )
}

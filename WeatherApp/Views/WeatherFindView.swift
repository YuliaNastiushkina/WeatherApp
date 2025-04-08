import SwiftUI
import SwiftData

struct WeatherFindView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var savedViewModel: SavedWeatherViewModel
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) var modelContext

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button(cancelButton) {
                    dismiss()
                }
                
                Spacer()
                
                Button(addButton) {
                    let weatherToSave = SavedWeathersModel(
                        city: viewModel.cityName,
                        temperature: viewModel.temperature,
                        description: viewModel.weatherDescription,
                        feelsLike: viewModel.feelsLike,
                        humidity: viewModel.humidity
                    )
                    savedViewModel.saveWeather(weatherToSave)
                    dismiss()
                }
            }
            .font(.headline)
            .foregroundColor(.blue.opacity(foregroundOpacity))
            .padding([.top, .horizontal])
            
            WeatherRowView(viewModel: viewModel)
        }
        .background(RoundedRectangle(cornerRadius: rowCornerRadiush)
            .fill(Color.white)
            .shadow(radius: shadowRadius))
    }
    
    //MARK: Private interface
    private let foregroundOpacity = 0.8
    private let rowCornerRadiush: CGFloat = 10
    private let shadowRadius: CGFloat = 5
    private let cancelButton = "Cancel"
    private let addButton = "Add"
}

#Preview {
    WeatherFindView(viewModel: previewViewModel, savedViewModel: previewSavedViewModel)
}

@MainActor
let previewSavedViewModel: SavedWeatherViewModel = {
    let container = try! ModelContainer(for: SavedWeathersModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return SavedWeatherViewModel(modelContext: container.mainContext)
}()

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var savedViewModel: SavedWeatherViewModel
    @Query var savedWeathers: [SavedWeathersModel]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        ZStack {
            Color.secondary.opacity(backgroundOpacity)
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    SearchView(viewModel: viewModel)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                
                if savedWeathers.isEmpty {
                    Image(systemName: "cloud.rainbow.crop.fill")
                        .resizable()
                        .frame(width: imageFrameSize, height: imageFrameSize)
                        .font(.largeTitle)
                        .foregroundStyle(.yellow)
                } else {
                    SavedWeathersView(viewModel: SavedWeatherViewModel(modelContext: modelContext))
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(progressViewScale)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(progressViewBackgroundOpacity).ignoresSafeArea())
            }
        }
        .sheet(isPresented: $viewModel.shouldShowWeather) {
            WeatherFindView(viewModel: viewModel, savedViewModel: savedViewModel)
        }
    }
    //MARK: Private interface
    private let backgroundOpacity: CGFloat = 0.1
    private let progressViewBackgroundOpacity: CGFloat = 0.5
    private let progressViewScale: CGFloat = 2.0
    private let imageFrameSize: CGFloat = 80
    
}

#Preview {
    let container = try! ModelContainer(for: SavedWeathersModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    return ContentViewWrapper()
        .modelContainer(container)
}

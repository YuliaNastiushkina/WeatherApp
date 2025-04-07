
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel(networkService: URLSession.shared)
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                SearchView(viewModel: viewModel)
                
                Spacer()
            }
            .padding()
            
            if viewModel.hasWeatherData {
                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.hasWeatherData {
                        WeatherView(viewModel: viewModel)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            } else {
                Image(systemName: "cloud.rainbow.crop.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .font(.largeTitle)
                    .foregroundStyle(.yellow)
            }
        }
    }
}

#Preview {
    ContentView()
}

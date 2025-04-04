import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        TextField("\(Image(systemName: "magnifyingglass")) Enter city", text: $viewModel.cityName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: viewModel.cityName, { _, _ in
                Task {
                    await viewModel.searchCities()
                }
            })
            .onSubmit {
                Task {
                    await viewModel.fetchWeather()
                }
            }
        if !viewModel.citySuggestions.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.citySuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.cityName = suggestion
                        viewModel.citySuggestions = []
                        Task {
                            await viewModel.fetchWeather()
                        }
                    }) {
                        Text(suggestion)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchView(viewModel: WeatherViewModel(networkService: URLSession.shared))
}

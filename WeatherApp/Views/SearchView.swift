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
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(viewModel.citySuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.cityName = suggestion
                        viewModel.citySuggestions = []
                        Task {
                            await viewModel.fetchWeather()
                        }
                    }) {
                        Text(suggestion)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(textFieldCornerRadius)
            .shadow(radius: shadowRadius)
            .padding(.horizontal)
        }
    }
    //MARK: Private interface
    private let spacing: CGFloat = 0
    private let textFieldCornerRadius: CGFloat = 10
    private let shadowRadius: CGFloat = 5
}

#Preview {
    SearchView(viewModel: WeatherViewModel(networkService: URLSession.shared))
}

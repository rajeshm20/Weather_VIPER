import SwiftUI

/// WeatherList View - VIPER View component
/// - Note: Passive view that only displays data from presenter
/// - Note: Follows SOLID - Single Responsibility (only UI rendering)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
struct WeatherListView: View {
    
    // MARK: - Properties
    
    @ObservedObject var presenter: WeatherListPresenter
    @State private var searchText = ""
    @State private var showingAddCity = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if presenter.isLoading && presenter.weatherList.isEmpty {
                loadingView
            } else if presenter.weatherList.isEmpty {
                emptyStateView
            } else {
                weatherListContent
            }
        }
        .navigationTitle("Weather")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            toolbarContent
        }
        .searchable(text: $searchText, prompt: "Search cities")
        .onSubmit(of: .search) {
            presenter.searchCity(searchText)
        }
        .sheet(isPresented: $showingAddCity) {
            citySearchSheet
        }
        .alert("Error", isPresented: $presenter.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(presenter.errorMessage)
        }
        .refreshable {
            await presenter.loadSavedWeather()
            await presenter.syncWeather()
        }
        .task {
            await presenter.loadSavedWeather()
        }
    }
    
    // MARK: - Subviews
    
    private var weatherListContent: some View {
        List {
            ForEach(presenter.weatherList) { weather in
                WeatherListRowView(weather: weather)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        presenter.didSelectWeather(weather)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            Task {
                                await presenter.deleteWeather(weather)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading weather data...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("No Cities Added")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add a city to see weather information")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddCity = true }) {
                Label("Add City", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var citySearchSheet: some View {
        NavigationStack {
            VStack {
                TextField("Enter city name", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onSubmit {
                        presenter.searchCity(searchText)
                    }
                
                if presenter.isSearching {
                    ProgressView()
                } else {
                    List(presenter.searchResults) { city in
                        Button(action: {
                            Task {
                                await presenter.addCity(city)
                                showingAddCity = false
                                searchText = ""
                            }
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(city.name)
                                    .font(.headline)
                                Text(city.countryCode)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAddCity = false
                        searchText = ""
                    }
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddCity = true }) {
                Image(systemName: "plus")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { presenter.navigateToSettings() }) {
                Image(systemName: "gear")
            }
        }
    }
}

/// Weather list row view component
struct WeatherListRowView: View {
    let weather: Weather
    
    var body: some View {
        HStack(spacing: 16) {
            // Weather icon
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(weather.fullLocation)
                    .font(.headline)
                
                Text(weather.description.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if weather.isOffline {
                    Label("Offline", systemImage: "wifi.slash")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            Text(weather.temperatureFormatted)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 8)
    }
}

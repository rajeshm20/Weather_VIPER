import Foundation
import Combine

/// WeatherList Presenter - VIPER Presenter component
/// - Note: Handles presentation logic, formats data for view
/// - Note: Follows SOLID - Single Responsibility (presentation only)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
@MainActor
final class WeatherListPresenter: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var weatherList: [Weather] = []
    @Published var searchResults: [City] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    // MARK: - Dependencies
    
    let router: WeatherListRouter
    let interactor: WeatherListInteractor
    
    // MARK: - Initialization
    
    init(router: WeatherListRouter, interactor: WeatherListInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: - Public Methods
    
    /// Load saved weather data from local storage
    func loadSavedWeather() async {
        isLoading = true
        
        do {
            weatherList = try await interactor.fetchSavedWeather()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    /// Sync weather data with remote API
    func syncWeather() async {
        do {
            weatherList = try await interactor.syncWeather()
        } catch {
            // Don't show error on background sync failure
            print("Sync failed: \(error)")
        }
    }
    
    /// Search for cities
    /// - Parameter query: Search query string
    func searchCity(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        Task {
            do {
                searchResults = try await interactor.searchCities(query: query)
            } catch {
                handleError(error)
            }
            isSearching = false
        }
    }
    
    /// Add city and fetch its weather
    /// - Parameter city: City to add
    func addCity(_ city: City) async {
        isLoading = true
        
        do {
            let weather = try await interactor.fetchWeather(for: city.name)
            weatherList.append(weather)
            
            // Also add to favorites
            try await interactor.addCityToFavorites(city)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    /// Delete weather from list
    /// - Parameter weather: Weather to delete
    func deleteWeather(_ weather: Weather) async {
        do {
            try await interactor.deleteWeather(id: weather.id)
            weatherList.removeAll { $0.id == weather.id }
        } catch {
            handleError(error)
        }
    }
    
    /// Handle weather selection
    /// - Parameter weather: Selected weather
    func didSelectWeather(_ weather: Weather) {
        router.navigateToDetail(weather: weather)
    }
    
    /// Navigate to settings
    func navigateToSettings() {
        router.navigateToSettings()
    }
    
    // MARK: - Private Methods
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}

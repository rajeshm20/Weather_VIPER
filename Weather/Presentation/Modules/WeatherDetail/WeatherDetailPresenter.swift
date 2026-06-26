import Foundation
import Combine

/// WeatherDetail Presenter - VIPER Presenter component
/// - Note: Formats weather data for detail view
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
@MainActor
final class WeatherDetailPresenter: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var weather: Weather
    
    // MARK: - Dependencies
    
    let router: WeatherDetailRouter
    let interactor: WeatherDetailInteractor
    
    // MARK: - Initialization
    
    init(
        weather: Weather,
        router: WeatherDetailRouter,
        interactor: WeatherDetailInteractor
    ) {
        self.weather = weather
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: - Public Methods
    
    /// Refresh weather data from API
    func refreshWeather() async {
        do {
            weather = try await interactor.refreshWeather(for: weather.cityName)
        } catch {
            print("Failed to refresh weather: \(error)")
        }
    }
    
    // MARK: - Formatting Methods
    
    /// Formatted timestamp string
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: weather.timestamp)
    }
    
    /// Formatted sync date string
    /// - Parameter date: Sync date
    /// - Returns: Formatted string
    func formattedSyncDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

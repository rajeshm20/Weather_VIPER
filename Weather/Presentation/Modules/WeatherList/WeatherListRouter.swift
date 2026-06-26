import Foundation

/// WeatherList Router - VIPER Router component
/// - Note: Handles navigation from WeatherList module
/// - Note: Follows SOLID - Single Responsibility (navigation only)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class WeatherListRouter: BaseRouterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - Initialization
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate to weather detail screen
    /// - Parameter weather: Weather data to display
    func navigateToDetail(weather: Weather) {
        coordinator?.navigate(to: .weatherDetail(weather))
    }
    
    /// Navigate to settings screen
    func navigateToSettings() {
        coordinator?.navigate(to: .settings)
    }
}

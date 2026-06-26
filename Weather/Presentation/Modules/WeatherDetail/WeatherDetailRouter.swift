import Foundation

/// WeatherDetail Router - VIPER Router component
/// - Note: Navigation logic for weather detail screen
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class WeatherDetailRouter: BaseRouterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - Initialization
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    
    /// Dismiss detail screen
    func dismiss() {
        coordinator?.pop()
    }
}

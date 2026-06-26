import Foundation

/// Settings Router - VIPER Router component
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class SettingsRouter: BaseRouterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - Initialization
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    
    func dismiss() {
        coordinator?.pop()
    }
}

import SwiftUI

/// Settings Module Builder
/// - Note: Assembles VIPER components for Settings module
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
enum SettingsModuleBuilder {
    
    /// Build Settings module
    /// - Parameters:
    ///   - coordinator: App coordinator
    ///   - dependencyContainer: Dependency container
    /// - Returns: Configured SettingsView
    @MainActor
    static func build(
        coordinator: AppCoordinator,
        dependencyContainer: DependencyContainer
    ) -> SettingsView {
        
        // Create Router
        let router = SettingsRouter(coordinator: coordinator)
        
        // Create Interactor
        let interactor = SettingsInteractor(
            weatherRepository: dependencyContainer.weatherRepository,
            syncWeatherUseCase: dependencyContainer.syncWeatherUseCase
        )
        
        // Create Presenter
        let presenter = SettingsPresenter(
            router: router,
            interactor: interactor
        )
        
        // Create View
        return SettingsView(presenter: presenter)
    }
}

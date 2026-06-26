import SwiftUI

/// WeatherDetail Module Builder
/// - Note: Assembles VIPER components for WeatherDetail module
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
enum WeatherDetailModuleBuilder {
    
    /// Build WeatherDetail module
    /// - Parameters:
    ///   - weather: Weather data to display
    ///   - coordinator: App coordinator
    ///   - dependencyContainer: Dependency container
    /// - Returns: Configured WeatherDetailView
    @MainActor
    static func build(
        weather: Weather,
        coordinator: AppCoordinator,
        dependencyContainer: DependencyContainer
    ) -> WeatherDetailView {
        
        // Create Router
        let router = WeatherDetailRouter(coordinator: coordinator)
        
        // Create Interactor
        let interactor = WeatherDetailInteractor(
            getWeatherUseCase: dependencyContainer.getWeatherUseCase
        )
        
        // Create Presenter
        let presenter = WeatherDetailPresenter(
            weather: weather,
            router: router,
            interactor: interactor
        )
        
        // Create View
        return WeatherDetailView(presenter: presenter)
    }
}

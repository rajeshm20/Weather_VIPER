import SwiftUI

/// WeatherList Module Builder
/// - Note: Assembles all VIPER components for WeatherList module
/// - Note: Follows SOLID - Dependency Inversion (builds with protocols)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
enum WeatherListModuleBuilder {
    
    /// Build WeatherList module with all dependencies
    /// - Parameters:
    ///   - coordinator: App coordinator for navigation
    ///   - dependencyContainer: Dependency injection container
    /// - Returns: Configured WeatherListView
    @MainActor
    static func build(
        coordinator: AppCoordinator,
        dependencyContainer: DependencyContainer
    ) -> WeatherListView {
        
        // Create Router
        let router = WeatherListRouter(coordinator: coordinator)
        
        // Create Interactor with use cases
        let interactor = WeatherListInteractor(
            getWeatherUseCase: dependencyContainer.getWeatherUseCase,
            getSavedWeatherListUseCase: dependencyContainer.getSavedWeatherListUseCase,
            syncWeatherUseCase: dependencyContainer.syncWeatherUseCase,
            manageFavoriteCitiesUseCase: dependencyContainer.manageFavoriteCitiesUseCase,
            cityRepository: dependencyContainer.cityRepository,
            weatherRepository: dependencyContainer.weatherRepository
        )
        
        // Create Presenter
        let presenter = WeatherListPresenter(
            router: router,
            interactor: interactor
        )
        
        // Create View
        let view = WeatherListView(presenter: presenter)
        
        return view
    }
}

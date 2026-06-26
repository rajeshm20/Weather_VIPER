import Foundation
import SwiftData

/// Dependency injection container
/// - Note: Follows SOLID - Dependency Inversion Principle
/// - Note: Centralized dependency management for Clean Architecture
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class DependencyContainer {
    
    // MARK: - Configuration
    
    private let configuration: AppConfiguration
    
    // MARK: - Infrastructure
    
    lazy var modelContainer: ModelContainer = {
        let schema = Schema([
            WeatherDataModel.self,
            CityDataModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
    
    lazy var networkService: NetworkServiceProtocol = {
        NetworkService(
            baseURL: configuration.apiBaseURL,
            apiKey: configuration.apiKey
        )
    }()
    
    // MARK: - Data Sources
    
    lazy var weatherRemoteDataSource: WeatherRemoteDataSourceProtocol = {
        WeatherRemoteDataSource(networkService: networkService)
    }()
    
    lazy var weatherLocalDataSource: WeatherLocalDataSourceProtocol = {
        WeatherLocalDataSource(modelContainer: modelContainer)
    }()
    
    lazy var cityLocalDataSource: CityLocalDataSourceProtocol = {
        CityLocalDataSource(modelContainer: modelContainer)
    }()
    
    // MARK: - Repositories
    
    lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(
            remoteDataSource: weatherRemoteDataSource,
            localDataSource: weatherLocalDataSource
        )
    }()
    
    lazy var cityRepository: CityRepositoryProtocol = {
        CityRepository(
            remoteDataSource: weatherRemoteDataSource,
            localDataSource: cityLocalDataSource
        )
    }()
    
    // MARK: - Use Cases
    
    lazy var getWeatherUseCase: GetWeatherUseCase = {
        GetWeatherUseCase(weatherRepository: weatherRepository)
    }()
    
    lazy var getSavedWeatherListUseCase: GetSavedWeatherListUseCase = {
        GetSavedWeatherListUseCase(weatherRepository: weatherRepository)
    }()
    
    lazy var syncWeatherUseCase: SyncWeatherUseCase = {
        SyncWeatherUseCase(weatherRepository: weatherRepository)
    }()
    
    lazy var manageFavoriteCitiesUseCase: ManageFavoriteCitiesUseCase = {
        ManageFavoriteCitiesUseCase(cityRepository: cityRepository)
    }()
    
    // MARK: - Initialization
    
    init(configuration: AppConfiguration) {
        self.configuration = configuration
    }
}

/// Application configuration
/// - Note: Holds environment-specific settings
struct AppConfiguration {
    let apiBaseURL: String
    let apiKey: String
    
    static let production = AppConfiguration(
        apiBaseURL: "https://api.openweathermap.org",
        apiKey: "3895cca5a93d5f4a613d00ebd9e05aba" // Replace with actual key
    )
    
    static let development = AppConfiguration(
        apiBaseURL: "https://api.openweathermap.org",
        apiKey: "3895cca5a93d5f4a613d00ebd9e05aba" // Replace with actual key
    )
}

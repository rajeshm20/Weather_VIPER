import Foundation

/// WeatherList Interactor - VIPER Interactor component
/// - Note: Contains business logic, orchestrates use cases
/// - Note: Follows SOLID - Single Responsibility (business logic only)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class WeatherListInteractor: BaseInteractorProtocol {
    
    // MARK: - Dependencies (Use Cases)
    
    private let getWeatherUseCase: GetWeatherUseCase
    private let getSavedWeatherListUseCase: GetSavedWeatherListUseCase
    private let syncWeatherUseCase: SyncWeatherUseCase
    private let manageFavoriteCitiesUseCase: ManageFavoriteCitiesUseCase
    private let cityRepository: CityRepositoryProtocol
    private let weatherRepository: WeatherRepositoryProtocol
    
    // MARK: - Initialization
    
    /// Initialize with use cases
    /// - Note: Dependency Injection via constructor
    init(
        getWeatherUseCase: GetWeatherUseCase,
        getSavedWeatherListUseCase: GetSavedWeatherListUseCase,
        syncWeatherUseCase: SyncWeatherUseCase,
        manageFavoriteCitiesUseCase: ManageFavoriteCitiesUseCase,
        cityRepository: CityRepositoryProtocol,
        weatherRepository: WeatherRepositoryProtocol
    ) {
        self.getWeatherUseCase = getWeatherUseCase
        self.getSavedWeatherListUseCase = getSavedWeatherListUseCase
        self.syncWeatherUseCase = syncWeatherUseCase
        self.manageFavoriteCitiesUseCase = manageFavoriteCitiesUseCase
        self.cityRepository = cityRepository
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Business Logic Methods
    
    /// Fetch weather for a city
    /// - Parameter cityName: Name of the city
    /// - Returns: Weather data
    func fetchWeather(for cityName: String) async throws -> Weather {
        try await getWeatherUseCase.execute(cityName: cityName)
    }
    
    /// Fetch all saved weather from local storage
    /// - Returns: Array of saved weather
    func fetchSavedWeather() async throws -> [Weather] {
        try await getSavedWeatherListUseCase.execute()
    }
    
    /// Sync all weather with remote API
    /// - Returns: Updated weather list
    func syncWeather() async throws -> [Weather] {
        try await syncWeatherUseCase.execute()
    }
    
    /// Search cities by name
    /// - Parameter query: Search query
    /// - Returns: Array of matching cities
    func searchCities(query: String) async throws -> [City] {
        try await cityRepository.searchCities(query: query)
    }
    
    /// Add city to favorites
    /// - Parameter city: City to add
    func addCityToFavorites(_ city: City) async throws {
        try await manageFavoriteCitiesUseCase.addToFavorites(city)
    }
    
    /// Delete weather from storage
    /// - Parameter id: Weather ID
    func deleteWeather(id: UUID) async throws {
        try await weatherRepository.deleteWeather(id: id)
    }
}

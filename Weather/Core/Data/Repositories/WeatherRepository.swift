import Foundation

/// Implementation of WeatherRepository with offline-first pattern
/// - Note: Follows SOLID - Dependency Inversion and Single Responsibility
/// - Note: Implements offline-first: local first, then remote with cache
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class WeatherRepository: WeatherRepositoryProtocol {
    
    // MARK: - Properties
    
    private let remoteDataSource: WeatherRemoteDataSourceProtocol
    private let localDataSource: WeatherLocalDataSourceProtocol
    
    // Cache validity duration (30 minutes)
    private let cacheValidityDuration: TimeInterval = 1800
    
    // MARK: - Initialization
    
    /// Initialize with data sources
    /// - Parameters:
    ///   - remoteDataSource: Remote API data source
    ///   - localDataSource: Local persistence data source
    init(
        remoteDataSource: WeatherRemoteDataSourceProtocol,
        localDataSource: WeatherLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    // MARK: - WeatherRepositoryProtocol
    
    /// Get weather with offline-first pattern
    /// - Parameter cityName: City name
    /// - Returns: Weather entity
    /// - Note: Strategy - Try local cache first, fetch remote on miss or stale data
    func getWeather(for cityName: String) async throws -> Weather {
        // Step 1: Try local cache first (offline-first)
        if let cachedModel = try await localDataSource.fetchWeather(for: cityName) {
            let cachedWeather = WeatherMapper.toDomain(from: cachedModel)
            
            // Check if cache is still valid
            if !cachedWeather.isStale {
                return cachedWeather
            }
        }
        
        // Step 2: Fetch from remote API
        do {
            let dto = try await remoteDataSource.fetchWeather(for: cityName)
            let weather = WeatherMapper.toDomain(from: dto)
            
            // Step 3: Save to local cache
            let model = WeatherMapper.toDataModel(from: weather)
            try await localDataSource.saveWeather(model)
            
            return weather
            
        } catch NetworkError.noInternetConnection {
            // Step 4: Return stale cache if no internet
            if let cachedModel = try await localDataSource.fetchWeather(for: cityName) {
                return WeatherMapper.toDomain(from: cachedModel)
            }
            throw NetworkError.noInternetConnection
        }
    }
    
    /// Get weather by coordinates with offline-first pattern
    func getWeather(latitude: Double, longitude: Double) async throws -> Weather {
        // Fetch from remote (coordinates don't have persistent cache key)
        let dto = try await remoteDataSource.fetchWeather(
            latitude: latitude,
            longitude: longitude
        )
        let weather = WeatherMapper.toDomain(from: dto)
        
        // Save to cache
        let model = WeatherMapper.toDataModel(from: weather)
        try await localDataSource.saveWeather(model)
        
        return weather
    }
    
    /// Get all saved weather from local storage
    func getSavedWeatherList() async throws -> [Weather] {
        let models = try await localDataSource.fetchAllWeather()
        return models.map { WeatherMapper.toDomain(from: $0) }
    }
    
    /// Save weather to local storage
    func saveWeather(_ weather: Weather) async throws {
        let model = WeatherMapper.toDataModel(from: weather)
        try await localDataSource.saveWeather(model)
    }
    
    /// Delete weather from local storage
    func deleteWeather(id: UUID) async throws {
        try await localDataSource.deleteWeather(id: id)
    }
    
    /// Sync all saved weather with remote API
    /// - Returns: Updated weather list
    /// - Note: Background sync operation for keeping cache fresh
    func syncAllWeather() async throws -> [Weather] {
        let savedWeather = try await getSavedWeatherList()
        var updatedWeather: [Weather] = []
        
        for weather in savedWeather {
            do {
                let fresh = try await getWeather(for: weather.cityName)
                updatedWeather.append(fresh)
            } catch {
                // Keep existing data on sync failure
                updatedWeather.append(weather)
            }
        }
        
        return updatedWeather
    }
    
    /// Clear all cached weather data
    func clearCache() async throws {
        try await localDataSource.clearAll()
    }
}

/// Implementation of CityRepository
final class CityRepository: CityRepositoryProtocol {
    
    private let remoteDataSource: WeatherRemoteDataSourceProtocol
    private let localDataSource: CityLocalDataSourceProtocol
    
    init(
        remoteDataSource: WeatherRemoteDataSourceProtocol,
        localDataSource: CityLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func searchCities(query: String) async throws -> [City] {
        let dtos = try await remoteDataSource.searchCities(query: query)
        return dtos.map { CityMapper.toDomain(from: $0) }
    }
    
    func getFavoriteCities() async throws -> [City] {
        let models = try await localDataSource.fetchFavoriteCities()
        return models.map { CityMapper.toDomain(from: $0) }
    }
    
    func addToFavorites(_ city: City) async throws {
        let favorites = try await getFavoriteCities()
        let order = favorites.count
        
        var updatedCity = city
        let model = CityMapper.toDataModel(from: City(
            id: updatedCity.id,
            name: updatedCity.name,
            countryCode: updatedCity.countryCode,
            latitude: updatedCity.latitude,
            longitude: updatedCity.longitude,
            isFavorite: true,
            favoriteOrder: order
        ))
        
        try await localDataSource.saveCities([model])
    }
    
    func removeFromFavorites(id: UUID) async throws {
        try await localDataSource.deleteCity(id: id)
    }
    
    func reorderFavorites(_ cities: [City]) async throws {
        for (index, city) in cities.enumerated() {
            let model = CityMapper.toDataModel(from: City(
                id: city.id,
                name: city.name,
                countryCode: city.countryCode,
                latitude: city.latitude,
                longitude: city.longitude,
                isFavorite: true,
                favoriteOrder: index
            ))
            try await localDataSource.updateCity(model)
        }
    }
}

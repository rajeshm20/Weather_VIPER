import Foundation
import SwiftData
import Combine

/// Protocol for local weather data operations
/// - Note: Follows SOLID - Dependency Inversion Principle
/// - Author: Senior iOS Technical Lead
protocol WeatherLocalDataSourceProtocol {
    @MainActor func saveWeather(_ model: WeatherDataModel) async throws
    @MainActor func fetchAllWeather() async throws -> [WeatherDataModel]
    @MainActor func fetchWeather(for cityName: String) async throws -> WeatherDataModel?
    @MainActor func deleteWeather(id: UUID) async throws
    @MainActor func clearAll() async throws
}

/// Local data source implementation using SwiftData
/// - Note: Handles all local persistence operations
/// - Author: Senior iOS Technical Lead
@MainActor
final class WeatherLocalDataSource: WeatherLocalDataSourceProtocol {
    
    // MARK: - Properties
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    
    /// Initialize with SwiftData model container
    /// - Parameter modelContainer: SwiftData container
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }
    
    // MARK: - WeatherLocalDataSourceProtocol
    
    /// Save or update weather data
    /// - Parameter model: WeatherDataModel to save
    func saveWeather(_ model: WeatherDataModel) async throws {
        // Extract value outside predicate (CRITICAL)
        let cityName = model.cityName

        let descriptor = FetchDescriptor<WeatherDataModel>(
            predicate: #Predicate<WeatherDataModel> {
                $0.cityName == cityName
            }
        )

        let existing = try modelContext.fetch(descriptor).first

        if let existing = existing {
            // Update existing record
            existing.temperature = model.temperature
            existing.feelsLike = model.feelsLike
            existing.tempMin = model.tempMin
            existing.tempMax = model.tempMax
            existing.pressure = model.pressure
            existing.humidity = model.humidity
            existing.weatherDescription = model.weatherDescription
            existing.weatherMain = model.weatherMain
            existing.icon = model.icon
            existing.windSpeed = model.windSpeed
            existing.cloudiness = model.cloudiness
            existing.timestamp = model.timestamp
            existing.lastSyncDate = Date()
        } else {
            // Insert new record
            modelContext.insert(model)
        }

        try modelContext.save()
    }
    
    /// Fetch all saved weather records
    /// - Returns: Array of weather data models
    func fetchAllWeather() async throws -> [WeatherDataModel] {
        let descriptor = FetchDescriptor<WeatherDataModel>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Fetch weather for specific city
    /// - Parameter cityName: Name of the city
    /// - Returns: Weather data model if found
    func fetchWeather(for cityName: String) async throws -> WeatherDataModel? {
        let descriptor = FetchDescriptor<WeatherDataModel>(
            predicate: #Predicate { $0.cityName == cityName }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    /// Delete weather record
    /// - Parameter id: Weather record ID
    func deleteWeather(id: UUID) async throws {
        let descriptor = FetchDescriptor<WeatherDataModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        if let model = try modelContext.fetch(descriptor).first {
            modelContext.delete(model)
            try modelContext.save()
        }
    }
    
    /// Clear all weather data
    func clearAll() async throws {
        try modelContext.delete(model: WeatherDataModel.self)
        try modelContext.save()
    }
}

/// Protocol for local city data operations
protocol CityLocalDataSourceProtocol {
    @MainActor func saveCities(_ models: [CityDataModel]) async throws
    @MainActor func fetchFavoriteCities() async throws -> [CityDataModel]
    @MainActor func updateCity(_ model: CityDataModel) async throws
    @MainActor func deleteCity(id: UUID) async throws
}

/// Local data source for city operations
@MainActor
final class CityLocalDataSource: CityLocalDataSourceProtocol {
    
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }
    
    func saveCities(_ models: [CityDataModel]) async throws {
        for model in models {
            modelContext.insert(model)
        }
        try modelContext.save()
    }
    
    func fetchFavoriteCities() async throws -> [CityDataModel] {
        let descriptor = FetchDescriptor<CityDataModel>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.favoriteOrder)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func updateCity(_ model: CityDataModel) async throws {
        try modelContext.save()
    }
    
    func deleteCity(id: UUID) async throws {
        let descriptor = FetchDescriptor<CityDataModel>(
            predicate: #Predicate { $0.id == id }
        )
        if let city = try modelContext.fetch(descriptor).first {
            modelContext.delete(city)
            try modelContext.save()
        }
    }
}

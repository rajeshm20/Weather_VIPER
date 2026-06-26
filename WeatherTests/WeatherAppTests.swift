//import XCTest
//@testable import Weather
//
///// Unit tests for GetWeatherUseCase
///// - Note: Tests business logic in isolation using mocks
///// - Author: Senior iOS Technical Lead
//final class GetWeatherUseCaseTests: XCTestCase {
//    
//    var sut: GetWeatherUseCase!
//    var mockRepository: MockWeatherRepository!
//    
//    override func setUp() {
//        super.setUp()
//        mockRepository = MockWeatherRepository()
//        sut = GetWeatherUseCase(weatherRepository: mockRepository)
//    }
//    
//    override func tearDown() {
//        sut = nil
//        mockRepository = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Tests
//    
//    func testExecute_WithValidCity_ReturnsWeather() async throws {
//        // Given
//        let expectedWeather = Weather.mock(cityName: "London")
//        mockRepository.weatherToReturn = expectedWeather
//        
//        // When
//        let result = try await sut.execute(cityName: "London")
//        
//        // Then
//        XCTAssertEqual(result.cityName, "London")
//        XCTAssertEqual(mockRepository.getWeatherCallCount, 1)
//    }
//    
//    func testExecute_WithInvalidCity_ThrowsError() async {
//        // Given
//        mockRepository.errorToThrow = NetworkError.serverError(statusCode: 404)
//        
//        // When/Then
//        do {
//            _ = try await sut.execute(cityName: "InvalidCity")
//            XCTFail("Expected error to be thrown")
//        } catch {
//            XCTAssertNotNil(error)
//        }
//    }
//}
//
///// Unit tests for WeatherListInteractor
//final class WeatherListInteractorTests: XCTestCase {
//    
//    var sut: WeatherListInteractor!
//    var mockGetWeatherUseCase: MockGetWeatherUseCase!
//    var mockSyncUseCase: MockSyncWeatherUseCase!
//    
//    override func setUp() {
//        super.setUp()
//        mockGetWeatherUseCase = MockGetWeatherUseCase()
//        mockSyncUseCase = MockSyncWeatherUseCase()
//        
//        sut = WeatherListInteractor(
//            getWeatherUseCase: mockGetWeatherUseCase,
//            getSavedWeatherListUseCase: MockGetSavedWeatherListUseCase(),
//            syncWeatherUseCase: mockSyncUseCase,
//            manageFavoriteCitiesUseCase: MockManageFavoriteCitiesUseCase(),
//            cityRepository: MockCityRepository(),
//            weatherRepository: MockWeatherRepository()
//        )
//    }
//    
//    func testFetchWeather_CallsUseCase() async throws {
//        // Given
//        let expectedWeather = Weather.mock(cityName: "Paris")
//        mockGetWeatherUseCase.weatherToReturn = expectedWeather
//        
//        // When
//        let result = try await sut.fetchWeather(for: "Paris")
//        
//        // Then
//        XCTAssertEqual(result.cityName, "Paris")
//        XCTAssertEqual(mockGetWeatherUseCase.executeCallCount, 1)
//    }
//    
//    func testSyncWeather_CallsSyncUseCase() async throws {
//        // Given
//        let expectedWeather = [Weather.mock(cityName: "London")]
//        mockSyncUseCase.weatherToReturn = expectedWeather
//        
//        // When
//        let result = try await sut.syncWeather()
//        
//        // Then
//        XCTAssertEqual(result.count, 1)
//        XCTAssertEqual(mockSyncUseCase.executeCallCount, 1)
//    }
//}
//
///// Integration tests for WeatherRepository
//final class WeatherRepositoryTests: XCTestCase {
//    
//    var sut: WeatherRepository!
//    var mockRemoteDataSource: MockRemoteDataSource!
//    var mockLocalDataSource: MockLocalDataSource!
//    
//    override func setUp() {
//        super.setUp()
//        mockRemoteDataSource = MockRemoteDataSource()
//        mockLocalDataSource = MockLocalDataSource()
//        
//        sut = WeatherRepository(
//            remoteDataSource: mockRemoteDataSource,
//            localDataSource: mockLocalDataSource
//        )
//    }
//    
//    func testOfflineFirst_WithValidCache_ReturnsCache() async throws {
//        // Given - Fresh cache (< 30 minutes old)
//        let cachedModel = WeatherDataModel.mock(cityName: "Berlin", timestamp: Date())
//        mockLocalDataSource.weatherToReturn = cachedModel
//        
//        // When
//        let result = try await sut.getWeather(for: "Berlin")
//        
//        // Then
//        XCTAssertEqual(result.cityName, "Berlin")
//        XCTAssertEqual(mockLocalDataSource.fetchCallCount, 1)
//        XCTAssertEqual(mockRemoteDataSource.fetchCallCount, 0, "Should not call remote when cache is valid")
//    }
//    
//    func testOfflineFirst_WithStaleCache_FetchesRemote() async throws {
//        // Given - Stale cache (> 30 minutes old)
//        let staleDate = Date().addingTimeInterval(-3600) // 1 hour ago
//        let cachedModel = WeatherDataModel.mock(cityName: "Tokyo", timestamp: staleDate)
//        mockLocalDataSource.weatherToReturn = cachedModel
//        
//        let freshDTO = WeatherResponseDTO.mock(cityName: "Tokyo")
//        mockRemoteDataSource.dtoToReturn = freshDTO
//        
//        // When
//        let result = try await sut.getWeather(for: "Tokyo")
//        
//        // Then
//        XCTAssertEqual(result.cityName, "Tokyo")
//        XCTAssertEqual(mockRemoteDataSource.fetchCallCount, 1, "Should fetch from remote when cache is stale")
//        XCTAssertEqual(mockLocalDataSource.saveCallCount, 1, "Should update cache")
//    }
//    
//    func testOfflineFirst_NoInternet_ReturnsStaleCache() async throws {
//        // Given
//        let staleDate = Date().addingTimeInterval(-3600)
//        let cachedModel = WeatherDataModel.mock(cityName: "Sydney", timestamp: staleDate)
//        mockLocalDataSource.weatherToReturn = cachedModel
//        mockRemoteDataSource.errorToThrow = NetworkError.noInternetConnection
//        
//        // When
//        let result = try await sut.getWeather(for: "Sydney")
//        
//        // Then
//        XCTAssertEqual(result.cityName, "Sydney")
//        XCTAssertTrue(result.isOffline, "Should mark as offline")
//    }
//}
//
//// MARK: - Mock Objects
//
//class MockWeatherRepository: WeatherRepositoryProtocol {
//    var weatherToReturn: Weather?
//    var errorToThrow: Error?
//    var getWeatherCallCount = 0
//    
//    func getWeather(for cityName: String) async throws -> Weather {
//        getWeatherCallCount += 1
//        if let error = errorToThrow {
//            throw error
//        }
//        return weatherToReturn ?? Weather.mock(cityName: cityName)
//    }
//    
//    func getWeather(latitude: Double, longitude: Double) async throws -> Weather {
//        return weatherToReturn ?? Weather.mock()
//    }
//    
//    func getSavedWeatherList() async throws -> [Weather] {
//        return [weatherToReturn].compactMap { $0 }
//    }
//    
//    func saveWeather(_ weather: Weather) async throws {}
//    func deleteWeather(id: UUID) async throws {}
//    func syncAllWeather() async throws -> [Weather] { [] }
//    func clearCache() async throws {}
//}
//
//class MockGetWeatherUseCase: GetWeatherUseCase {
//    var weatherToReturn: Weather?
//    var executeCallCount = 0
//    
//    init() {
//        super.init(weatherRepository: MockWeatherRepository())
//    }
//    
//    override func execute(cityName: String) async throws -> Weather {
//        executeCallCount += 1
//        return weatherToReturn ?? Weather.mock(cityName: cityName)
//    }
//}
//
//class MockSyncWeatherUseCase: SyncWeatherUseCase {
//    var weatherToReturn: [Weather] = []
//    var executeCallCount = 0
//    
//    init() {
//        super.init(weatherRepository: MockWeatherRepository())
//    }
//    
//    override func execute() async throws -> [Weather] {
//        executeCallCount += 1
//        return weatherToReturn
//    }
//}
//
//// MARK: - Mock Extensions
//
//extension Weather {
//    static func mock(
//        cityName: String = "Test City",
//        temperature: Double = 20.0
//    ) -> Weather {
//        Weather(
//            cityName: cityName,
//            countryCode: "TC",
//            temperature: temperature,
//            feelsLike: 19.0,
//            tempMin: 18.0,
//            tempMax: 22.0,
//            pressure: 1013,
//            humidity: 65,
//            description: "Clear sky",
//            main: "Clear",
//            icon: "01d",
//            windSpeed: 3.5,
//            cloudiness: 10
//        )
//    }
//}
//
//extension WeatherDataModel {
//    static func mock(
//        cityName: String = "Test City",
//        timestamp: Date = Date()
//    ) -> WeatherDataModel {
//        WeatherDataModel(
//            cityName: cityName,
//            countryCode: "TC",
//            temperature: 20.0,
//            feelsLike: 19.0,
//            tempMin: 18.0,
//            tempMax: 22.0,
//            pressure: 1013,
//            humidity: 65,
//            weatherDescription: "Clear sky",
//            weatherMain: "Clear",
//            icon: "01d",
//            windSpeed: 3.5,
//            cloudiness: 10,
//            timestamp: timestamp
//        )
//    }
//}
//
//extension WeatherResponseDTO {
//    static func mock(cityName: String = "Test City") -> WeatherResponseDTO {
//        WeatherResponseDTO(
//            coord: WeatherResponseDTO.Coordinates(lon: 0, lat: 0),
//            weather: [
//                WeatherResponseDTO.WeatherInfo(
//                    id: 800,
//                    main: "Clear",
//                    description: "clear sky",
//                    icon: "01d"
//                )
//            ],
//            base: "stations",
//            main: WeatherResponseDTO.MainWeather(
//                temp: 20.0,
//                feelsLike: 19.0,
//                tempMin: 18.0,
//                tempMax: 22.0,
//                pressure: 1013,
//                humidity: 65
//            ),
//            visibility: 10000,
//            wind: WeatherResponseDTO.Wind(speed: 3.5, deg: 180),
//            clouds: WeatherResponseDTO.Clouds(all: 10),
//            dt: Int(Date().timeIntervalSince1970),
//            sys: WeatherResponseDTO.System(
//                country: "TC",
//                sunrise: 1234567890,
//                sunset: 1234567890
//            ),
//            timezone: 0,
//            id: 123,
//            name: cityName,
//            cod: 200
//        )
//    }
//}

import SwiftUI
import Combine

/// Navigation destination enumeration
/// - Note: Defines all possible navigation destinations
/// - Author: Senior iOS Technical Lead
enum Destination: Hashable {
    case weatherList
    case weatherDetail(Weather)
    case settings
}

/// App Coordinator for managing navigation flow
/// - Note: Centralized navigation logic following Coordinator pattern
/// - Note: Works with SwiftUI NavigationStack
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
@MainActor
final class AppCoordinator: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Navigation path for NavigationStack
    @Published var path: [Destination] = []
    
    /// Current presented sheet
    @Published var presentedSheet: Destination?
    
    /// Full screen cover
    @Published var fullScreenCover: Destination?
    
    // MARK: - Dependencies
    
    let dependencyContainer: DependencyContainer
    
    // MARK: - Initialization
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate to destination using push
    /// - Parameter destination: Target destination
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    /// Present destination as sheet
    /// - Parameter destination: Target destination
    func present(_ destination: Destination) {
        presentedSheet = destination
    }
    
    /// Present destination as full screen cover
    /// - Parameter destination: Target destination
    func presentFullScreen(_ destination: Destination) {
        fullScreenCover = destination
    }
    
    /// Dismiss current sheet or cover
    func dismiss() {
        presentedSheet = nil
        fullScreenCover = nil
    }
    
    /// Pop to previous screen
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Pop to root
    func popToRoot() {
        path.removeAll()
    }
    
    /// Build view for destination
    /// - Parameter destination: Destination to build
    /// - Returns: Appropriate view for destination
    @ViewBuilder
    func build(for destination: Destination) -> some View {
        switch destination {
        case .weatherList:
            buildWeatherListModule()
            
        case .weatherDetail(let weather):
            buildWeatherDetailModule(weather: weather)
            
        case .settings:
            buildSettingsModule()
        }
    }
    
    // MARK: - Module Builders
    
    private func buildWeatherListModule() -> some View {
        WeatherListModuleBuilder.build(
            coordinator: self,
            dependencyContainer: dependencyContainer
        )
    }
    
    private func buildWeatherDetailModule(weather: Weather) -> some View {
        WeatherDetailModuleBuilder.build(
            weather: weather,
            coordinator: self,
            dependencyContainer: dependencyContainer
        )
    }
    
    private func buildSettingsModule() -> some View {
        SettingsModuleBuilder.build(
            coordinator: self,
            dependencyContainer: dependencyContainer
        )
    }
}

// MARK: - Hashable Conformance for Weather

extension Weather: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

import SwiftUI
import SwiftData

/// Main App Entry Point
/// - Note: Initializes dependency container and coordinator
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
@main
struct WeatherApp: App {
    
    // MARK: - Properties
    
    @StateObject private var coordinator: AppCoordinator
    
    // MARK: - Initialization
    
    init() {
        // Initialize dependency container with production configuration
        let dependencyContainer = DependencyContainer(
            configuration: .production
        )
        
        // Initialize coordinator
        let coordinator = AppCoordinator(
            dependencyContainer: dependencyContainer
        )
        
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
                .modelContainer(coordinator.dependencyContainer.modelContainer)
        }
    }
}

/// ContentView with Navigation
/// - Note: Root navigation stack managed by coordinator
struct ContentView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(for: .weatherList)
                .navigationDestination(for: Destination.self) { destination in
                    coordinator.build(for: destination)
                }
        }
        .sheet(item: $coordinator.presentedSheet) { destination in
            NavigationStack {
                coordinator.build(for: destination)
            }
        }
        .fullScreenCover(item: $coordinator.fullScreenCover) { destination in
            NavigationStack {
                coordinator.build(for: destination)
            }
        }
    }
}

// MARK: - Destination Identifiable Conformance

extension Destination: Identifiable {
    var id: String {
        switch self {
        case .weatherList:
            return "weatherList"
        case .weatherDetail(let weather):
            return "weatherDetail_\(weather.id)"
        case .settings:
            return "settings"
        }
    }
}

import SwiftUI

/// Settings View - VIPER View component
/// - Note: App settings and configuration screen
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
struct SettingsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var presenter: SettingsPresenter
    @State private var showingClearConfirmation = false
    
    // MARK: - Body
    
    var body: some View {
        List {
            appInfoSection
            cacheSection
            aboutSection
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Clear Cache", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                Task {
                    await presenter.clearCache()
                }
            }
        } message: {
            Text("This will delete all cached weather data. Are you sure?")
        }
    }
    
    // MARK: - Sections
    
    private var appInfoSection: some View {
        Section("App Information") {
            HStack {
                Text("Version")
                Spacer()
                Text(presenter.appVersion)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Build")
                Spacer()
                Text(presenter.buildNumber)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var cacheSection: some View {
        Section("Data Management") {
            HStack {
                Text("Cached Cities")
                Spacer()
                Text("\(presenter.cachedCitiesCount)")
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                Task {
                    await presenter.syncAllData()
                }
            }) {
                HStack {
                    Label("Sync All Data", systemImage: "arrow.triangle.2.circlepath")
                    Spacer()
                    if presenter.isSyncing {
                        ProgressView()
                    }
                }
            }
            .disabled(presenter.isSyncing)
            
            Button(role: .destructive, action: {
                showingClearConfirmation = true
            }) {
                Label("Clear Cache", systemImage: "trash")
            }
        }
    }
    
    private var aboutSection: some View {
        Section("About") {
            Link(destination: URL(string: "https://openweathermap.org")!) {
                HStack {
                    Text("Weather Data Provider")
                    Spacer()
                    Text("OpenWeatherMap")
                        .foregroundColor(.secondary)
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text("Architecture")
                Spacer()
                Text("VIPER + Clean")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Offline Support")
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

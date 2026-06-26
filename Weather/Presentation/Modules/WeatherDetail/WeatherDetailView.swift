import SwiftUI

/// WeatherDetail View - VIPER View component
/// - Note: Displays detailed weather information
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
struct WeatherDetailView: View {
    
    // MARK: - Properties
    
    @ObservedObject var presenter: WeatherDetailPresenter
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                currentWeatherSection
                detailsGrid
                additionalInfoSection
                
                if presenter.weather.isOffline {
                    offlineIndicator
                }
            }
            .padding()
        }
        .navigationTitle(presenter.weather.cityName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContent
        }
        .refreshable {
            await presenter.refreshWeather()
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(presenter.weather.icon)@4x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
            .frame(width: 120, height: 120)
            
            Text(presenter.weather.temperatureFormatted)
                .font(.system(size: 72, weight: .thin))
            
            Text(presenter.weather.description.capitalized)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Feels like \(String(format: "%.1f°C", presenter.weather.feelsLike))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    private var currentWeatherSection: some View {
        HStack(spacing: 40) {
            VStack(spacing: 4) {
                Image(systemName: "thermometer.low")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Min")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(String(format: "%.1f°C", presenter.weather.tempMin))
                    .font(.headline)
            }
            
            VStack(spacing: 4) {
                Image(systemName: "thermometer.high")
                    .font(.title2)
                    .foregroundColor(.red)
                Text("Max")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(String(format: "%.1f°C", presenter.weather.tempMax))
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var detailsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            DetailCard(
                icon: "humidity.fill",
                title: "Humidity",
                value: "\(presenter.weather.humidity)%",
                color: .cyan
            )
            
            DetailCard(
                icon: "wind",
                title: "Wind Speed",
                value: String(format: "%.1f m/s", presenter.weather.windSpeed),
                color: .green
            )
            
            DetailCard(
                icon: "gauge.medium",
                title: "Pressure",
                value: "\(presenter.weather.pressure) hPa",
                color: .orange
            )
            
            DetailCard(
                icon: "cloud.fill",
                title: "Cloudiness",
                value: "\(presenter.weather.cloudiness)%",
                color: .gray
            )
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Information")
                .font(.headline)
            
            InfoRow(
                label: "Location",
                value: presenter.weather.fullLocation
            )
            
            InfoRow(
                label: "Last Updated",
                value: presenter.formattedTimestamp
            )
            
            if let syncDate = presenter.weather.lastSyncDate {
                InfoRow(
                    label: "Last Synced",
                    value: presenter.formattedSyncDate(syncDate)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var offlineIndicator: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text("Showing cached data (Offline)")
                .font(.subheadline)
        }
        .foregroundColor(.orange)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                Task {
                    await presenter.refreshWeather()
                }
            }) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
}

// MARK: - Supporting Views

struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

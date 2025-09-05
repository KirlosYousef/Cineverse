import Foundation
import TelemetryDeck

/// Service for sending analytics signals via TelemetryDeck.
final class TelemetryService {
    // MARK: - Signal Names
    struct Signal {
        static let appStarted = "App.Started"
        static let movieListViewed = "Movies.ListViewed"
        static let movieDetailsViewed = "Movies.DetailsViewed"
        static let favoriteToggled = "Movies.FavoriteToggled"
        static let networkError = "Network.Error"
    }
    
    // MARK: - Singleton
    static let shared = TelemetryService()
    private init() {}
    
    // MARK: - Public API
    func send(_ signal: String, payload: [String: String]? = nil) {
        TelemetryDeck.signal(signal, parameters: payload ?? [:])
    }
} 

# Cineverse

[![CI](https://github.com/kirlosyousef/Cineverse/actions/workflows/ci.yml/badge.svg)](https://github.com/kirlosyousef/Cineverse/actions/workflows/ci.yml)

A modern iOS application that allows users to explore popular movies using The Movie Database (TMDB) API. Built with Clean Architecture and MVVM design patterns, featuring pagination, search, caching, analytics, and full accessibility support.

## Features

- **Grid Layout**: Browse popular movies in a responsive grid
- **Movie Details**: SwiftUI-powered detail screens with comprehensive information
- **Pagination**: Infinite scroll with automatic loading
- **Search**: Real-time, debounced search with cancellation support
- **Favorites**: Local storage with persistent favorites management
- **Caching**: Multi-layer caching (memory + disk) for optimal performance
- **Analytics**: Telemetry tracking for user behavior and app performance
- **Accessibility**: Full VoiceOver support with semantic labels
- **Error Handling**: Robust error states with retry mechanisms
- **Modern UI**: Dark theme with smooth animations

## Requirements Mapping

| Feature | Implementation | Key Components | Rationale |
|---------|---------------|----------------|-----------|
| **Detail Screen** | SwiftUI + UIKit Bridge | Detail View, ViewModel, Action Buttons | Modern declarative UI with better accessibility |
| **Pagination** | Infinite Scroll | Movies ViewModel, View Controller | Automatic loading with page tracking |
| **Search** | Debounced, Cancellable | Movies ViewModel, View Controller | 400ms debounce prevents excessive API calls |
| **Structured Concurrency** | async/await + Task Management | ViewModels, Network Service, Retry Utility | Modern Swift concurrency with proper cancellation |
| **SwiftUI** | Hybrid Architecture | Detail View, Action Buttons | Better accessibility and modern UI patterns |
| **Accessibility** | VoiceOver Support | Movie Cells, Detail View, Action Buttons | Comprehensive accessibility labels and hints |
| **Testing** | Unit Tests + Swift Testing | ViewModel Tests, Cache Tests | Focus on pagination, search, error paths |
| **Security** | API Key Management | Configuration Files, Git Ignore | Secure API key storage |
| **CI/CD** | GitHub Actions | Workflow Files, Project Configuration | Automated testing on multiple Xcode versions |

### Limitations & Future Work

- **Storage**: UserDefaults for favorites; Core Data would provide better scalability
- **Localization**: English-only interface
- **Advanced Search**: Basic text search only; could add filters (genre, year, rating)

## Architecture

Clean Architecture with MVVM pattern ensuring clear separation of concerns and testability.

### Data Flow
```
UI (UIKit/SwiftUI) → ViewModel → UseCase → Repository → NetworkService/CacheService
```

### Key Components

#### Presentation Layer
- **UIKit Views**: MoviesViewController, MovieCell for list/grid display
- **SwiftUI Views**: MovieDetailView, ActionButtons for modern detail experience
- **ViewModels**: MoviesViewModel, MovieDetailsViewModel with reactive state management

#### Domain Layer
- **Entities**: Movie model with Codable support
- **Use Cases**: GetPopularMoviesUseCase with retry logic
- **Protocols**: Repository and service contracts for dependency inversion

#### Data Layer
- **Network**: NetworkService with Alamofire, connectivity checks, and error handling
- **Repository**: MovieRepository with caching layer integration
- **Services**: FavoritesService, CacheService for local data management

## Dependencies

- **Alamofire**: Network requests with async/await support
- **SDWebImage**: Efficient image loading and caching
- **TelemetryDeck**: Privacy-focused analytics and telemetry

## Project Setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/kirlosyousef/Cineverse.git
   cd Cineverse
   ```

2. **Configure API Key**
   Create a `Secrets.xcconfig` file in the project root:
   ```bash
   # Get your API key from https://www.themoviedb.org/settings/api
   echo "TMDB_API_KEY = your_api_key_here" > Secrets.xcconfig
   ```

3. **Add to Xcode Project Configuration**
   - Open `Cineverse.xcodeproj`
   - Select the project in the navigator
   - Go to "Info" tab
   - Add `Secrets.xcconfig` to the "Configuration Files" section
   - Ensure both Debug and Release configurations reference the file

4. **Build and Run**
   ```bash
   # Using Xcode
   open Cineverse.xcodeproj
   # Press Cmd+R to build and run

   # Using command line
   xcodebuild -project Cineverse.xcodeproj -scheme Cineverse -destination 'platform=iOS Simulator,name=iPhone 16' build
   ```

## Quality Assurance

### Testing
- **Unit Tests**: Focus on pagination, search, error handling, and data layer
- **Mock Objects**: Comprehensive mocking for network and data services
- **Test Coverage**: MoviesViewModelTests, CacheServiceTests, MovieDetailsViewModelTests

### Accessibility
- **VoiceOver**: Full support with semantic labels and navigation hints
- **Dynamic Type**: Support for system font size preferences
- **Accessibility Identifiers**: Unique identifiers for UI testing

### CI/CD
- **GitHub Actions**: Automated testing on macOS 14 with Xcode 16.2
- **Build Matrix**: Tests on multiple Xcode versions
- **Test Results**: Automated collection and reporting with artifacts

## Design Decisions & Trade-offs

### 1. **UserDefaults for Favorites**
- **Choice**: Simple key-value storage for favorites
- **Rationale**: Quick implementation with automatic persistence
- **Trade-off**: Limited scalability; Core Data would be better for production

### 2. **Multi-layer Caching**
- **Choice**: Memory + disk caching with SDWebImage
- **Rationale**: Optimal performance with offline capability
- **Trade-off**: Increased memory usage; configurable limits prevent issues

### 3. **Clean Architecture**
- **Choice**: Three-layer architecture with dependency injection
- **Rationale**: Clear separation of concerns and testability
- **Trade-off**: More boilerplate code but better maintainability

## Running Tests

```bash
# In Xcode
Cmd+U

# Command line
xcodebuild test -project Cineverse.xcodeproj -scheme Cineverse -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Requirements

- **iOS**: 17.0+
- **Xcode**: 16.0+
- **Swift**: 5.9+

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

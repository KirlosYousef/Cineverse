# MovieExplorer

A modern iOS application that allows users to explore popular movies using The Movie Database (TMDB) API. Built with Clean Architecture and MVVM design patterns, the app provides a seamless user experience for browsing movies, viewing details, and managing favorites.

## Features

- Browse popular movies in a beautiful grid layout
- View detailed information about each movie
- Save favorite movies locally
- Smooth transitions
- Error handling and loading states
- Modern iOS UI with dark theme

## Architecture

The app follows Clean Architecture principles with MVVM pattern, divided into three main layers:

### 1. Presentation Layer
- **Views**: UIKit-based views (`MoviesViewController`, `MovieDetailsViewController`, `MovieCell`)
- **ViewModels**: Handle presentation logic and state management (`MoviesViewModel`, `MovieDetailsViewModel`)
- Implements data binding for reactive UI updates

### 2. Domain Layer
- **Models**: Core business models (`Movie`)
- **Use Cases**: Business logic operations (`GetPopularMoviesUseCase`)
- **Protocols**: Define contracts for repositories and services

### 3. Data Layer
- **Network**: API communication using Alamofire (`NetworkService`)
- **Repositories**: Data source abstraction (`MovieRepository`)
- **Services**: Local data management (`FavoritesService`)

## Dependencies

- **Alamofire**: Network requests handling
- **SDWebImage**: Efficient image loading and caching

## Project Setup

1. Clone the repository
2. Create a `Secrets.xcconfig` file in the project root with:
   ```
   TMDB_API_KEY = your_api_key_here
   ```
3. Open `MovieExplorer.xcodeproj`
4. Build and run

## Design Decisions & Trade-offs

1. **UserDefaults for Favorites**
   - Used for simplicity and quick implementation
   - For a production app, would be better using Core Data for better scalability

2. **Clean Architecture**
   - Provides clear separation of concerns
   - Makes the codebase more testable and maintainable
   - Slightly more boilerplate code, but worth it for larger apps

4. **MVVM Pattern**
   - Clear separation between view and business logic
   - Easier to test
   - Good balance between simplicity and functionality

## Testing

The project includes unit tests for:
- Use Cases
- Data Models

Run tests using Cmd+U in Xcode.

## Future Improvements

1. Implement Core Data for local storage
2. Add movie search functionality
3. Implement movie categories/genres
4. Add movie trailers and reviews
5. Support for light/dark mode themes
6. Offline support
7. Localization

## Requirements

- iOS 17.6+
- Xcode 15.0+
- Swift 5.9+

## License

This project is available under the MIT license. See the LICENSE file for more info.

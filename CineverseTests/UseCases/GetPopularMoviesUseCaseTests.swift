//
//  GetPopularMoviesUseCaseTests.swift
//  CineverseTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
@testable import Cineverse

struct GetPopularMoviesUseCaseTests {
    // MARK: - Test Doubles
    
    class MockMovieRepository: MovieRepositoryProtocol {
        var getPopularMoviesCalled = false
        var lastPage: Int?
        var lastQuery: String?
        var resultToReturn: Result<[Movie], Error>?
        
        func getPopularMovies(page: Int, query: String?) async throws -> [Movie] {
            getPopularMoviesCalled = true
            lastPage = page
            lastQuery = query
            if let result = resultToReturn {
                switch result {
                case .success(let movies):
                    return movies
                case .failure(let error):
                    throw error
                }
            }
            return []
        }
    }
    
    // MARK: - Tests
    
    @Test("Use case successfully fetches movies from repository")
    func testExecuteSuccess() async throws {
        // Given
        let mockRepository = MockMovieRepository()
        let sut = GetPopularMoviesUseCase(repository: mockRepository)
        let expectedMovies = [
            Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: "/poster1.jpg", releaseDate: "2025-07-10", voteAverage: 7.5),
            Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: "/poster2.jpg", releaseDate: "2025-07-10", voteAverage: 9.0)
        ]
        mockRepository.resultToReturn = .success(expectedMovies)
        
        // When
        let movies = try await sut.execute(page: 1, query: nil)
        
        // Then
        #expect(mockRepository.getPopularMoviesCalled)
        #expect(mockRepository.lastPage == 1)
        #expect(mockRepository.lastQuery == nil)
        #expect(movies.count == 2)
        #expect(movies[0].id == 1)
        #expect(movies[0].title == "Test Movie 1")
        #expect(movies[1].id == 2)
        #expect(movies[1].title == "Test Movie 2")
    }
    
    @Test("Use case properly handles repository errors")
    func testExecuteFailure() async throws {
        // Given
        let mockRepository = MockMovieRepository()
        let sut = GetPopularMoviesUseCase(repository: mockRepository)
        let expectedError = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRepository.resultToReturn = .failure(expectedError)
        
        // When & Then
        do {
            _ = try await sut.execute(page: 1, query: nil)
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(mockRepository.getPopularMoviesCalled)
            let nsError = error as NSError
            #expect(nsError.domain == expectedError.domain)
            #expect(nsError.code == expectedError.code)
            #expect(nsError.localizedDescription == expectedError.localizedDescription)
        }
    }
    
    @Test("Use case passes correct parameters to repository")
    func testExecuteWithParameters() async throws {
        // Given
        let mockRepository = MockMovieRepository()
        let sut = GetPopularMoviesUseCase(repository: mockRepository)
        mockRepository.resultToReturn = .success([])
        
        // When
        _ = try await sut.execute(page: 3, query: "batman")
        
        // Then
        #expect(mockRepository.getPopularMoviesCalled)
        #expect(mockRepository.lastPage == 3)
        #expect(mockRepository.lastQuery == "batman")
    }
} 

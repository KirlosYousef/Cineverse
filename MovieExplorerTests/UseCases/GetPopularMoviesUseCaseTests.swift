//
//  GetPopularMoviesUseCaseTests.swift
//  MovieExplorerTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
@testable import MovieExplorer

final class GetPopularMoviesUseCaseTests {
    // MARK: - Test Doubles
    
    class MockMovieRepository: MovieRepositoryProtocol {
        var getPopularMoviesCalled = false
        var resultToReturn: Result<[Movie], Error>?
        
        func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
            getPopularMoviesCalled = true
            if let result = resultToReturn {
                completion(result)
            }
        }
    }
    
    // MARK: - Properties
    
    var sut: GetPopularMoviesUseCase!
    var mockRepository: MockMovieRepository!
    
    // MARK: - Setup & Teardown
    
    func setUp() {
        mockRepository = MockMovieRepository()
        sut = GetPopularMoviesUseCase(repository: mockRepository)
    }
    
    func tearDown() {
        sut = nil
        mockRepository = nil
    }
    
    // MARK: - Tests
    
    @Test("Use case successfully fetches movies from repository")
    func testExecuteSuccess() async throws {
        setUp()
        defer { tearDown() }
        
        // Given
        let expectedMovies = [
            Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: "/poster1.jpg", releaseDate: "2025-07-10", voteAverage: 7.5),
            Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: "/poster2.jpg", releaseDate: "2025-07-10", voteAverage: 9.0)
        ]
        mockRepository.resultToReturn = .success(expectedMovies)
        
        // When
        var receivedResult: Result<[Movie], Error>?
        sut.execute { result in
            receivedResult = result
        }
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockRepository.getPopularMoviesCalled)
        
        switch receivedResult {
        case .success(let movies):
            #expect(movies.map(\.id) == expectedMovies.map(\.id))
            #expect(movies.map(\.title) == expectedMovies.map(\.title))
        case .failure, .none:
            #expect(Bool(false), "Expected success with movies, but got \(String(describing: receivedResult))")
        }
    }
    
    @Test("Use case properly handles repository errors")
    func testExecuteFailure() async throws {
        setUp()
        defer { tearDown() }
        
        // Given
        let expectedError = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRepository.resultToReturn = .failure(expectedError)
        
        // When
        var receivedResult: Result<[Movie], Error>?
        sut.execute { result in
            receivedResult = result
        }
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000) 
        #expect(mockRepository.getPopularMoviesCalled)
        
        switch receivedResult {
        case .success:
            #expect(Bool(false), "Expected failure, but got success")
        case .failure(let error as NSError):
            #expect(error.domain == expectedError.domain)
            #expect(error.code == expectedError.code)
            #expect(error.localizedDescription == expectedError.localizedDescription)
        case .none:
            #expect(Bool(false), "Expected failure result, but got nil")
        }
    }
} 

//
//  RetryUtility.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation
import Alamofire

/// Utility for retrying operations with exponential backoff
struct RetryUtility {
    
    /// Retries an async operation with exponential backoff
    ///
    /// - Parameters:
    ///   - maxAttempts: Maximum number of retry attempts (default: 3)
    ///   - baseDelay: Base delay in seconds for exponential backoff (default: 1.0)
    ///   - maxDelay: Maximum delay in seconds (default: 10.0)
    ///   - operation: The async operation to retry
    /// - Returns: The result of the operation
    /// - Throws: The last error if all retries fail
    static func retry<T>(
        maxAttempts: Int = 3,
        baseDelay: TimeInterval = 1.0,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                
                // Don't retry on the last attempt
                guard attempt < maxAttempts else { break }
                
                // Don't retry for certain types of errors
                if !shouldRetry(error: error) {
                    throw error
                }
                
                // Delay to retry
                try await Task.sleep(nanoseconds: UInt64(baseDelay * 1_000_000_000))
            }
        }
        
        throw lastError ?? NSError(domain: "RetryUtility", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
    }
    
    /// Determines if an error should trigger a retry
    ///
    /// - Parameter error: The error to evaluate
    /// - Returns: True if the operation should be retried
    private static func shouldRetry(error: Error) -> Bool {
        // Retry on network connectivity issues
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noConnection:
                return true
            case .invalidURL, .noData:
                return false
            }
        }
        
        // Retry on URLError network issues
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .timedOut,
                 .cannotConnectToHost,
                 .cannotFindHost:
                return true
            default:
                return false
            }
        }
        
        // Retry on HTTP 5xx server errors
        if let afError = error as? AFError,
           case .responseValidationFailed(let reason) = afError,
           case .unacceptableStatusCode(let code) = reason,
           code >= 500 {
            return true
        }
        
        // Don't retry for other errors
        return false
    }
}

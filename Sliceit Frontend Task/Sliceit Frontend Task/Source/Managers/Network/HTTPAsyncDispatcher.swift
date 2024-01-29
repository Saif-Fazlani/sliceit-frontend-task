//
//  HTTPAsyncDispatcher.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

public enum HTTPAsyncRequestError: Error, LocalizedError {
    case badResponse
    case networkError(String?)
    case empty
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case badGateway
    case serviceUnavailable
    case unknown
    case parseError(String?)
    case urlConstructionFailed
    case noInternetConnection
}

class HTTPAsyncDispatcher<T> where T: Codable {
    
    func parse(_ data: Data?) -> Result<T, HTTPAsyncRequestError> {
        guard let data = data else { return .failure(HTTPAsyncRequestError.badResponse) }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            return .success(response)
        } catch let exception {
            return .failure(HTTPAsyncRequestError.parseError("Parsable error: \(exception.localizedDescription)"))
        }
    }
    
    func verify(response: T?, statusCode: Int) async throws -> T? {
        switch statusCode {
        case 200..<300:
            guard let response = response else {
                throw HTTPAsyncRequestError.empty
            }
            return response
        case 401:
            throw HTTPAsyncRequestError.unauthorized
        case 403:
            throw HTTPAsyncRequestError.forbidden
        case 404:
            throw HTTPAsyncRequestError.notFound
        case 500:
            throw HTTPAsyncRequestError.internalServerError
        case 502:
            throw HTTPAsyncRequestError.badGateway
        case 503:
            throw HTTPAsyncRequestError.serviceUnavailable
        default:
            throw HTTPAsyncRequestError.unknown
        }
    }

    
}

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
    
    func verify(response: T?, statusCode: Int) -> Result<T?, HTTPAsyncRequestError> {
        switch statusCode {
        case 200..<300:
            guard let response else {
                return .failure(.empty)
            }
            return .success(response)
        case 401:
            return .failure(HTTPAsyncRequestError.unauthorized)
        case 403:
            return .failure(HTTPAsyncRequestError.forbidden)
        case 404:
            return .failure(HTTPAsyncRequestError.notFound)
        case 500:
            return .failure(HTTPAsyncRequestError.internalServerError)
        case 502:
            return .failure(HTTPAsyncRequestError.badGateway)
        case 503:
            return .failure(HTTPAsyncRequestError.serviceUnavailable)
        default:
            return .failure(HTTPAsyncRequestError.unknown)
        }
    }
    
}

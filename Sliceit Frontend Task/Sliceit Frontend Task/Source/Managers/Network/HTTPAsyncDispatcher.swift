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

class HTTPAsyncDispatcher<Response> where Response: Decodable {
    
    func parse(_ data: Data?) async throws -> Response {
        guard let data = data else { throw HTTPAsyncRequestError.badResponse }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: data)
            return response
        } catch let exception {
            throw HTTPAsyncRequestError.parseError("Parsable error: \(exception.localizedDescription)")
        }
    }
    
    func verify(response: Response?, statusCode: Int) async throws -> Response? {
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

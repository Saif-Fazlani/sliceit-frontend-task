//
//  MockDataManager.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

enum GenericError: Error {
    case fileNotFound
}

class MockDataManager<Response: Decodable> {
    
    static func loadMockData(fileName: String) async throws -> Response {
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                return try JSONDecoder().decode(Response.self, from: data)
            } catch(let error) {
                throw error
            }
        } else {
            throw GenericError.fileNotFound
        }
    }
    
}

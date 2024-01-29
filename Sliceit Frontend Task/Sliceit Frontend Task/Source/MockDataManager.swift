//
//  MockDataManager.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

class MockDataManager<Response: Decodable> {
    
    static func loadMockData(fileName: String) -> Response? {
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                return try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        } else {
            print("JSON file not found.")
            return nil
        }
    }
    
}

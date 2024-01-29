//
//  URLRequest-Ext.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

extension URLRequest {

    public init(url: URL,
                method: RequestMethod,
                header: [String: String]?,
                body: Any?,
                timeoutInterval: Double) {
        
        self.init(url: url)
        self.timeoutInterval = timeoutInterval
        self.method = method

        header?.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = body {
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                // Handle the error if needed
            }
        }
    }
}


extension URLRequest {
    
    public enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    public var method: RequestMethod? {
        get {
            guard let requestMethod = self.httpMethod else { return nil }
            let method = RequestMethod(rawValue: requestMethod)
            return method
        } set {
            self.httpMethod = newValue?.rawValue
        }
    }
}

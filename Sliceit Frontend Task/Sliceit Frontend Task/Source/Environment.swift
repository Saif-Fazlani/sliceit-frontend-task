//
//  Environment.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

enum APIConstants {
    static let baseURL = "" //Add base URL here
    static let mainPageInfo = "/info"
    static let login = "/login"
    
    static func profileInfo() -> String {
        var components = URLComponents()
        components.path = "/profile"
        components.queryItems = [
            URLQueryItem(name: "token", value: UserDefaults.standard.authToken.orNil),
        ]
        return (components.url?.absoluteString).orNil
    }
    
    static func authorInfo() -> String {
        var components = URLComponents()
        components.path = "/author"
        components.queryItems = [
            URLQueryItem(name: "token", value: UserDefaults.standard.authToken.orNil),
        ]
        return (components.url?.absoluteString).orNil
    }
    
    static func authorQuote(authorId: String) -> String {
        var components = URLComponents()
        components.path = "/profile"
        components.queryItems = [
            URLQueryItem(name: "token", value: UserDefaults.standard.authToken.orNil),
            URLQueryItem(name: "authorId", value: authorId)
        ]
        return (components.url?.absoluteString).orNil
    }
    
    static func signOut() -> String {
        var components = URLComponents()
        components.path = "/logout"
        components.queryItems = [
            URLQueryItem(name: "token", value: UserDefaults.standard.authToken.orNil),
        ]
        return (components.url?.absoluteString).orNil
    }
}

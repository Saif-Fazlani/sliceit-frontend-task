//
//  Constants.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import Foundation

enum Constants {
    
    enum Mock {
        //File names
        static let info = "Info"
        static let authorInfo = "AuthorInfo"
        static let authorQuote = "AuthorQuote"
        static let loginResponse = "LoginResponse"
        static let logoutResponse = "LogoutResponse"
        static let profileInfo = "ProfileInfo"
        
        //Response time
        static let serverResponseTime: UInt64 = 1_000_000_000 / 2
    }
    
}

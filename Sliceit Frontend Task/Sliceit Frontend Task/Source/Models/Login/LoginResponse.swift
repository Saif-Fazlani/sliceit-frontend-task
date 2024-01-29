//
//  LoginResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    var success: Bool?
    var data: LoginResponseData?
}

// MARK: - DataClass
struct LoginResponseData: Codable {
    var token: String?
}

//
//  ProfileResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - ProfileResponse
struct ProfileResponse: Codable {
    var success: Bool?
    var data: ProfileResponseData?
}

// MARK: - DataClass
struct ProfileResponseData: Codable {
    var fullname: String?
    var email: String?
}

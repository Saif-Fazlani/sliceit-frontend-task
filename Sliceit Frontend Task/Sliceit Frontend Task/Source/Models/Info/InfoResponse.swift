//
//  InfoResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - InfoResponse
struct InfoResponse: Codable {
    var success: Bool?
    var data: InfoResponseData?
}

// MARK: - DataClass
struct InfoResponseData: Codable {
    var info: String?
}

//
//  AuthorInfoResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - AuthorInfoResponse
struct AuthorInfoResponse: Codable {
    var success: Bool?
    var data: AuthorInfoResponseData?
}

// MARK: - DataClass
struct AuthorInfoResponseData: Codable {
    var authorId: Int?
    var name: String?
}

//
//  AuthorQuoteResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - AuthorQuoteResponse
struct AuthorQuoteResponse: Codable {
    var success: Bool?
    var data: AuthorQuoteResponseData?
}

// MARK: - DataClass
struct AuthorQuoteResponseData: Codable {
    var quoteId: Int?
    var authorId: Int?
    var quote: String?
}

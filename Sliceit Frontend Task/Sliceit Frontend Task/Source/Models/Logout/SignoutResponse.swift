//
//  SignoutResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - SignoutResponse
struct SignoutResponse: Codable {
    var success: Bool?
    var data: SignoutResponseData?
}

// MARK: - DataClass
struct SignoutResponseData: Codable {}

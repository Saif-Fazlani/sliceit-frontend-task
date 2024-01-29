//
//  LogoutResponse.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

// MARK: - LogoutResponse
struct LogoutResponse: Codable {
    var success: Bool?
    var data: LogoutResponseData?
}

// MARK: - DataClass
struct LogoutResponseData: Codable {}

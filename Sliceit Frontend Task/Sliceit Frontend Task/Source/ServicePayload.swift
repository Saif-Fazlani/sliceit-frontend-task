//
//  ServicePayload.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation
import UIKit

struct ServicePayload {
    
    init() {}
    
    private var apiEndpoint: String?
    private var parameters: [String: Any]?
    private var requestType: URLRequest.RequestMethod?
    private var timeoutInterval: Double? = 30.0
}

extension ServicePayload {
    
    func getEndPoint() -> String? {
        return apiEndpoint
    }

    func getParameters() -> [String: Any]? {
        return parameters
    }
    
    func getRequestType() -> URLRequest.RequestMethod {
        return requestType ?? .get
    }
    
    func getTimeoutInterval() -> Double {
        return timeoutInterval ?? 30.0
    }
    
    mutating func setPayload(apiEndPoint: String? = nil,
                             parameters: [String: Any]? = nil,
                             requestType: URLRequest.RequestMethod? = nil,
                             timeoutInterval: Double? = 15.0) {
        self.apiEndpoint = apiEndPoint
        self.parameters = parameters
        self.requestType = requestType
        self.timeoutInterval = timeoutInterval
    }
    
    func getHeaders() -> [String: String] {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["accept"] = "*/*"
        headers["Authorization"] = UserDefaults.standard.isUserLoggedIn ? "Bearer \(UserDefaults.standard.authToken.orNil)" : "Bearer anonymous"
        return headers
    }
}

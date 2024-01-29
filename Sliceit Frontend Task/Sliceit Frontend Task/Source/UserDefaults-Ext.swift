//
//  UserDefaults-Ext.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

extension UserDefaults {
    
    enum Key: String, CaseIterable {
        case authToken
        case isUserLoggedIn
    }
    
    var authToken: String? {
        get {
            return value(forKey: Key.authToken.rawValue) as? String
        }
        set {
            setValue(newValue, forKey: Key.authToken.rawValue)
        }
    }
    
    public var isUserLoggedIn: Bool {
        get {
            return bool(forKey: Key.isUserLoggedIn.rawValue)
        }
        set {
            set(newValue, forKey: Key.isUserLoggedIn.rawValue)
            synchronize()
        }
    }
}

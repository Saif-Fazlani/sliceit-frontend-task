//
//  Network-Ext.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

extension Dictionary {
    
    var getJsonFromDictionary: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch _ {
            return nil
        }
    }
    
}

extension Data {
    
    var getJSONFromData: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
    
    var getDictFromData: [String: Any] {
        guard let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else { return [:] }
        return dict
    }
    
}

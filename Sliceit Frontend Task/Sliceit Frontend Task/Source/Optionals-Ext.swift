//
//  Optionals-Ext.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

extension String? {
    var orNil: String {
        return self ?? ""
    }
}

extension Bool? {
    var orFalse: Bool {
        return self ?? false
    }
}

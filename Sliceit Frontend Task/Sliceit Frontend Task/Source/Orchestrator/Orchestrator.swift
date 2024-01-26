//
//  Orchestrator.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

final class Orchestrator {

    let navigationDelegate: NavigationDelegate
        
    init(navigationDelegate: NavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }

    func bootstrap() -> UIViewController {
        return navigationDelegate.bootstrap(orchestrator: self)
    }

}

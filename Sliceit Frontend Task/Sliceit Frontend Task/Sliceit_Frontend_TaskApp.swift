//
//  Sliceit_Frontend_TaskApp.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

@main
struct Sliceit_Frontend_TaskApp: App {
    
    struct AppArchitecture: AppRepresentable {
        func configureOperationalEnvironment() -> Orchestrator {
            let navigationDelegate = NavigationDelegateImpl()
            return Orchestrator(navigationDelegate: navigationDelegate)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppArchitecture()
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

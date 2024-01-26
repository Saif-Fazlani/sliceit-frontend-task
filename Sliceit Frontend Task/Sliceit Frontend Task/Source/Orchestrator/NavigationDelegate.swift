//
//  NavigationDelegate.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import UIKit

protocol NavigationDelegate: AnyObject {
    func bootstrap(orchestrator: Orchestrator) -> UIViewController
}

final class NavigationDelegateImpl: NavigationDelegate {
    
    let masterRootNavigationController = MasterNavigationController(isNavigationBarHidden: true)
    
    func bootstrap(orchestrator: Orchestrator) -> UIViewController {
        launchInitialFlow(orchestrator: orchestrator)
        return masterRootNavigationController
    }
    
    private func launchInitialFlow(orchestrator: Orchestrator) {
        let initialViewState = InitialViewState()
        let initialView = InitialAssembler.assambleInitialView(state: initialViewState) { route in
            switch route {
            case .next:
                self.launchLoginFlow(orchestrator: orchestrator)
            case .back:
                self.masterRootNavigationController.pop()
            }
        }
        masterRootNavigationController.push(to: initialView)
    }
    
    private func launchLoginFlow(orchestrator: Orchestrator) {
        let loginViewState = LoginViewState()
        let loginView = LoginViewAssembler.assambleLoginView(state: loginViewState) { route in
            switch route {
            case .next:
                break
            case .back:
                self.masterRootNavigationController.pop()
            }
        }
        masterRootNavigationController.push(to: loginView)
    }
    
}

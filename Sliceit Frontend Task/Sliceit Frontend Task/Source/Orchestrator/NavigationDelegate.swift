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
        let initialLoader = InitialAssembler.assambleInitialView(state: initialViewState) { route in
            switch route {
            case .next:
                break
            case .back:
                break
            }
        }
        masterRootNavigationController.push(to: initialLoader)
    }
    
}

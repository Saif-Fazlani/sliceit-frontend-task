//
//  InitialAssembler.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

enum InitialRoute {
    case next
    case back
}

typealias InitialViewNavigationAction = (InitialRoute) -> Void

struct InitialAssembler {
    static func assambleInitialView(state: InitialViewState,
                         navigationAction: @escaping InitialViewNavigationAction) -> UIHostingController<InitialView> {
        let interactor = InitialViewInteractorImpl(state: state, navigation: navigationAction)
        return UIHostingController(rootView: InitialView(state: state, interactor: interactor))
    }
}

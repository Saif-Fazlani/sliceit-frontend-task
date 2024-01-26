//
//  LoginAssembler.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

enum LoginRoute {
    case next
    case back
}

typealias LoginViewNavigationAction = (LoginRoute) -> Void

struct LoginViewAssembler {
    static func assambleLoginView(state: LoginViewState,
                         navigationAction: @escaping LoginViewNavigationAction) -> UIHostingController<LoginView> {
        let interactor = LoginViewInteractorImpl(state: state, navigation: navigationAction)
        return UIHostingController(rootView: LoginView(state: state, interactor: interactor))
    }
}

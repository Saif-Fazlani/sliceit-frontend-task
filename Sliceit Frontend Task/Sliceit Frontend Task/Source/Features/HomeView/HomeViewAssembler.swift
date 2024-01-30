//
//  HomeViewAssembler.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import SwiftUI

enum HomeRoute {
    case next
    case back
}

typealias HomeViewNavigationAction = (HomeRoute) -> Void

struct HomeViewAssembler {
    static func assambleHomeView(state: HomeViewState,
                         navigationAction: @escaping HomeViewNavigationAction) -> UIHostingController<HomeView> {
        let interactor = HomeViewInteractorImpl(state: state, navigation: navigationAction)
        return UIHostingController(rootView: HomeView(state: state, interactor: interactor))
    }
}

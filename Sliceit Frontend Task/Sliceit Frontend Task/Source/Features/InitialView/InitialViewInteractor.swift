//
//  InitialInteractor.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import Foundation

protocol InitialViewInteractor: AnyObject {
    func onAppear()
    func onTapAboutUs()
    func onTapSignIn()
}

final class InitialViewInteractorImpl: InitialViewInteractor {
    
    private let state: InitialViewState
    private let navigationAction: InitialViewNavigationAction
    
    init (
        state: InitialViewState,
        navigation: @escaping InitialViewNavigationAction
    ) {
        self.state = state
        self.navigationAction = navigation
    }
    
    func onAppear() {
        configureState()
    }
    
    private func configureState() {
        state.title = "Little story about the company"
        state.btnAboutUsTitle = "About us"
        state.btnSignInTitle = "Sign in"
    }
    
    func onTapAboutUs() {
        //
    }
    
    func onTapSignIn() {
        navigationAction(.next)
    }
    
}

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
        fetchInfo()
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
    
    func fetchInfo() {
        state.isLoading = true
        Task {
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.mainPageInfo, requestType: .get)
                let request = HTTPAsyncManager<InfoResponse> { [weak self] data in
                    self?.state.infoResponse = data
                }
                try await request.generateRequest(payload)
                state.isLoading = false
                
            } catch(let error) {
                state.isLoading = false
                state.alertState = .init(
                    tag: .internalError,
                    title: "Unable to connect",
                    message: error.localizedDescription,
                    primaryAction: .cancel(title: "OK"),
                    secondaryAction: nil
                )
            }
        }
    }
}

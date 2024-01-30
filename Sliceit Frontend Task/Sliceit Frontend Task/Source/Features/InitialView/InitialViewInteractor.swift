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
    
    @MainActor
    func onAppear() {
        configureState()
        fetchInfo()
    }
    
    private func configureState() {
        state.btnAboutUsTitle = "About us"
        state.btnSignInTitle = "Sign in"
    }
    
    func onTapAboutUs() {
        // Didn't know what action to perform on this one
    }
    
    func onTapSignIn() {
        navigationAction(.next)
    }
    
    func setInfo(response: InfoResponse) {
        guard let data = response.data,
              response.success.orFalse == true else { return }
        state.title = data.info.orNil
    }
    
    @MainActor
    func fetchInfo() {
        Task {
            state.isLoading = true
            do {
                let requestManager = HTTPAsyncManager<InfoResponse>()
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.mainPageInfo, requestType: .get)
                let infoResponse = try await requestManager.generateRequest(payload)
                setInfo(response: infoResponse)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                let mockData = try await MockDataManager<InfoResponse>.loadMockData(fileName: Constants.Mock.info)
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setInfo(response: mockData)
            }
        }
    }
}

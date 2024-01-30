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
    
    func setInfo(data: InfoResponse) {
        state.infoResponse = data
        state.title = (data.data?.info).orNil
    }
    
    @MainActor
    func fetchInfo() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.mainPageInfo, requestType: .get)
                let requestManager = HTTPAsyncManager<InfoResponse>()
                state.infoResponse = try await requestManager.generateRequest(payload)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<InfoResponse>.loadMockData(fileName: Constants.Mock.info) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setInfo(data: mockData)
            }
        }
    }
}

//
//  HomeInteractor.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import Foundation

protocol HomeViewInteractor: AnyObject {
    func onAppear()
    func onTapUpdate()
    func onTapSignOut()
}

final class HomeViewInteractorImpl: HomeViewInteractor {
    
    private let state: HomeViewState
    private let navigationAction: HomeViewNavigationAction
    
    init (
        state: HomeViewState,
        navigation: @escaping HomeViewNavigationAction
    ) {
        self.state = state
        self.navigationAction = navigation
    }
    
    @MainActor
    func onAppear() {
        configureState()
        fetchProfileInfo()
    }
    
    private func configureState() {
        state.btnUpdateTitle = "Update"
        state.btnSignOutTitle = "Sign out"
    }
    
    private func setProfileInfo(data: ProfileResponse) {
        state.profileResponse = data
        state.welcomeMessage = "Welcome, \((data.data?.fullname).orNil)!"
    }
    
    func onTapUpdate() {
        //
    }
    
    func onTapSignOut() {
        //
    }
    
    @MainActor
    func fetchProfileInfo() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.profileInfo(), requestType: .get)
                let requestManager = HTTPAsyncManager<ProfileResponse>()
                state.profileResponse = try await requestManager.generateRequest(payload)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<ProfileResponse>.loadMockData(fileName: Constants.Mock.profileInfo) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setProfileInfo(data: mockData)
            }
        }
    }
}

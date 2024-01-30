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
    func onTapCancel()
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
        state.popupTitle = "Requesting the Quote"
        state.popupStepOne = "Step 1: Requesting the author"
        state.popupStepTwo = "Step 2: Requesting the quote"
        state.btnUpdateTitle = "Update"
        state.btnSignOutTitle = "Sign out"
    }
    
    private func setProfileInfo(response: ProfileResponse) {
        guard let data = response.data else { return }
        state.welcomeMessage = "Welcome, \(data.fullname.orNil)!"
    }
    
    private func setAuthorInfo(response: AuthorInfoResponse) {
        guard let data = response.data else { return }
        state.authorName = data.name.orNil
        state.authorId = data.authorId.orZero.description
    }
    
    private func setAuthorQuote(response: AuthorQuoteResponse) {
        guard let data = response.data else { return }
        state.authorQuote = data.quote.orNil
    }
    
    func onTapUpdate() {
        state.isPopupVisible = true
    }
    
    func onTapSignOut() {
        //
    }
    
    func onTapCancel() {
        state.isPopupVisible = false
    }
    
    @MainActor
    func fetchProfileInfo() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.profileInfo(), requestType: .get)
                let requestManager = HTTPAsyncManager<ProfileResponse>()
                let profileResponse = try await requestManager.generateRequest(payload)
                setProfileInfo(response: profileResponse)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<ProfileResponse>.loadMockData(fileName: Constants.Mock.profileInfo) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setProfileInfo(response: mockData)
            }
        }
    }
    
    @MainActor
    func fetchAuthorInfo() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.authorInfo(), requestType: .get)
                let requestManager = HTTPAsyncManager<AuthorInfoResponse>()
                let authorInfoResponse = try await requestManager.generateRequest(payload)
                setAuthorInfo(response: authorInfoResponse)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<AuthorInfoResponse>.loadMockData(fileName: Constants.Mock.authorInfo) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setAuthorInfo(response: mockData)
            }
        }
    }
    
    @MainActor
    func fetchAuthorQuote() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.authorQuote(authorId: state.authorId), requestType: .get)
                let requestManager = HTTPAsyncManager<AuthorQuoteResponse>()
                let authorQuoteResponse = try await requestManager.generateRequest(payload)
                setAuthorQuote(response: authorQuoteResponse)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<AuthorQuoteResponse>.loadMockData(fileName: Constants.Mock.authorQuote) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setAuthorQuote(response: mockData)
            }
        }
    }
}

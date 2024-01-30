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
    private var longTask: Task<(), Never>?
    
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
        state.btnUpdateTitle = "Update"
        state.btnSignOutTitle = "Sign out"
    }
    
    private func setProfileInfo(response: ProfileResponse) {
        guard let data = response.data else { return }
        state.welcomeMessage = "Welcome, \(data.fullname.orNil)!"
    }
    
    private func setAuthorInfo(response: AuthorInfoResponse) {
        state.isLoading = false
        guard let data = response.data else { return }
        state.authorName = data.name.orNil
        state.authorId = data.authorId.orZero.description
        state.popupStepOne.append("completed")
    }
    
    private func setAuthorQuote(response: AuthorQuoteResponse) {
        state.isLoading = false
        guard let data = response.data else { return }
        state.authorQuote = data.quote.orNil
        state.popupStepTwo.append("completed")
    }
    
    @MainActor
    func onTapUpdate() {
        Task {
            state.isPopupVisible = true
            fetchLongAuthorInfo()
        }
    }
    
    func onTapSignOut() {
        //
    }
    
    func onTapCancel() {
        cancelFetching()
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
    func fetchAuthorInfo() async {
        Task {
            state.isLoading = true
            state.popupStepOne = "Requesting author..."
            
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.authorInfo(), requestType: .get)
                let requestManager = HTTPAsyncManager<AuthorInfoResponse>()
                let authorInfoResponse = try await requestManager.generateRequest(payload)
                setAuthorInfo(response: authorInfoResponse)
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<AuthorInfoResponse>.loadMockData(fileName: Constants.Mock.authorInfo) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.longServerResponseTime)
                setAuthorInfo(response: mockData)
            }
        }
    }
    
    @MainActor
    func fetchAuthorQuote() async {
        Task {
            state.isLoading = true
            state.popupStepTwo = "Requesting quote..."
            
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.authorQuote(authorId: state.authorId), requestType: .get)
                let requestManager = HTTPAsyncManager<AuthorQuoteResponse>()
                let authorQuoteResponse = try await requestManager.generateRequest(payload)
                setAuthorQuote(response: authorQuoteResponse)
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<AuthorQuoteResponse>.loadMockData(fileName: Constants.Mock.authorQuote) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.longServerResponseTime)
                setAuthorQuote(response: mockData)
            }
        }
    }
    
    @MainActor
    func fetchLongAuthorInfo() {
        longTask = Task {
            state.isLoading = true
            defer { state.isLoading = false }

            do {
                await fetchAuthorInfo()
                //
                try Task.checkCancellation()
                //
                await fetchAuthorQuote()
                //
                try Task.checkCancellation()
                //
                state.authorText = "\(state.authorName) said: \(state.authorQuote)"
                
            } catch is CancellationError {
                print("Task is cancelled")
            } catch {
                print("Error fetching author and quote: \(error.localizedDescription)")
            }
        }
    }

    func cancelFetching() {
        longTask?.cancel()
        state.isLoading = false
        state.isPopupVisible = false
    }
}

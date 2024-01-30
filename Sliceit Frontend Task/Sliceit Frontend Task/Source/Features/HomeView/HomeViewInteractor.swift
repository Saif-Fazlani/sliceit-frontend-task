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
    
    private func configurePopupLabels() {
        state.popupStepOne = "Requesting author..."
        state.popupStepTwo = "Requesting quote..."
    }
    
    private func setProfileInfo(response: ProfileResponse) {
        guard let data = response.data else { return }
        state.welcomeMessage = "Welcome, \(data.fullname.orNil)!"
    }
    
    @MainActor
    private func setAuthorInfo(response: AuthorInfoResponse) async {
        state.isLoading = false
        guard let data = response.data else { return }
        state.authorName = data.name.orNil
        state.authorId = data.authorId.orZero.description
        state.popupStepOne.append("completed")
    }
    
    @MainActor
    private func setAuthorQuote(response: AuthorQuoteResponse) async {
        state.isLoading = false
        guard let data = response.data else { return }
        state.authorQuote = data.quote.orNil
        state.popupStepTwo.append("completed")
    }
    
    func setSignOut(response: SignoutResponse) {
        guard let data = response.data else { return }
        //
        UserDefaults.standard.isUserLoggedIn = false
        UserDefaults.standard.authToken = nil
    }
    
    @MainActor
    func onTapUpdate() {
        Task {
            state.isPopupVisible = true
            fetchLongAuthorInfo()
        }
    }
    
    @MainActor
    func onTapSignOut() {
        Task {
            signOutUser()
        }
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
                let mockData = try await MockDataManager<ProfileResponse>.loadMockData(fileName: Constants.Mock.profileInfo)
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setProfileInfo(response: mockData)
            }
        }
    }
    
    @MainActor
    func fetchAuthorInfo() async {
        state.isLoading = true
        
        do {
            var payload = ServicePayload()
            payload.setPayload(apiEndPoint: APIConstants.authorInfo(), requestType: .get)
            let requestManager = HTTPAsyncManager<AuthorInfoResponse>()
            let authorInfoResponse = try await requestManager.generateRequest(payload)
            await setAuthorInfo(response: authorInfoResponse)
            
        } catch(let error) {
            print(error.localizedDescription)
            // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
            
            do {
                let mockData = try await MockDataManager<AuthorInfoResponse>.loadMockData(fileName: Constants.Mock.authorInfo)
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.longServerResponseTime)
                //
                await setAuthorInfo(response: mockData)
                
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func fetchAuthorQuote() async {
        state.isLoading = true
        
        do {
            var payload = ServicePayload()
            payload.setPayload(apiEndPoint: APIConstants.authorQuote(authorId: state.authorId), requestType: .get)
            let requestManager = HTTPAsyncManager<AuthorQuoteResponse>()
            let authorQuoteResponse = try await requestManager.generateRequest(payload)
            await setAuthorQuote(response: authorQuoteResponse)
            
        } catch(let error) {
            print(error.localizedDescription)
            // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
            do {
                let mockData = try await MockDataManager<AuthorQuoteResponse>.loadMockData(fileName: Constants.Mock.authorQuote)
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.longServerResponseTime)
                //
                await setAuthorQuote(response: mockData)
                
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func fetchLongAuthorInfo() {
        longTask = Task {
            
            configurePopupLabels()
            
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
                processLongTaskCompletion()
                
            } catch is CancellationError {
                print("Task is cancelled")
            } catch {
                print("Error fetching author and quote: \(error.localizedDescription)")
            }
        }
    }
    
    func processLongTaskCompletion() {
        if !(longTask?.isCancelled).orFalse {
            state.authorText = "\(state.authorName) said: \(state.authorQuote)"
        } else {
            state.authorText = ""
        }
        //
        state.isPopupVisible = false
        configurePopupLabels()
    }
    
    func cancelFetching() {
        longTask?.cancel()
        state.isLoading = false
        state.isPopupVisible = false
        configurePopupLabels()
    }
    
    @MainActor
    func signOutUser() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                payload.setPayload(apiEndPoint: APIConstants.signOut(),
                                   requestType: .delete)
                let requestManager = HTTPAsyncManager<SignoutResponse>()
                let signOutResponse = try await requestManager.generateRequest(payload)
                setSignOut(response: signOutResponse)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                let mockData = try await MockDataManager<SignoutResponse>.loadMockData(fileName: Constants.Mock.signOutResponse)
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setSignOut(response: mockData)
            }
            navigationAction(.signout)
        }
    }
}

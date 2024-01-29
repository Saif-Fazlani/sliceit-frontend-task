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
                state.isLoading = false
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = loadMockData() else { return }
                state.infoResponse = mockData
            }
        }
    }
    
    func loadMockData() -> InfoResponse? {
        if let fileURL = Bundle.main.url(forResource: "Info", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                return try JSONDecoder().decode(InfoResponse.self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        } else {
            print("JSON file not found.")
            return nil
        }
    }
}

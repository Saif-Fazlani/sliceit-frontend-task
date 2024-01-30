//
//  LoginInteractor.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import Foundation

protocol LoginViewInteractor: AnyObject {
    func onAppear()
    func onTapBack()
    func updateEmail(value: String)
    func updatePassword(value: String)
    func updatePasswordSecureState(value: Bool)
    func validateSubmit()
    func onSubmit()
}

final class LoginViewInteractorImpl: LoginViewInteractor {
    
    private let state: LoginViewState
    private let navigationAction: LoginViewNavigationAction
    
    init (
        state: LoginViewState,
        navigation: @escaping LoginViewNavigationAction
    ) {
        self.state = state
        self.navigationAction = navigation
    }
    
    func onAppear() {
        configureState()
    }
    
    private func configureState() {
        state.tfEmailLabel = "Email address"
        state.tfEmailPlaceholder = "Enter email"
        state.errorMsgEmail = "Invalid email"
        state.tfPasswordLabel = "Password"
        state.tfPasswordPlaceholder = "Enter password"
        state.errorMsgPassword = "Must be 8 characters with at least 1 letter and 1 digit."
        state.btnSubmitTitle = "Submit"
    }
    
    func onTapBack() {
        navigationAction(.back)
    }
    
    func updateEmail(value: String) {
        state.email = value
        state.isEmailValid = value.isValid(regex: Regex.email())
    }
    
    func updatePassword(value: String) {
        state.password = value
        state.isPasswordValid = value.isValid(regex: Regex.password())
    }
    
    func updatePasswordSecureState(value: Bool) {
        state.isTfPasswordSecure = value
    }
    
    func setLogin(response: LoginResponse) {
        guard let data = response.data else { return }
        //
        UserDefaults.standard.isUserLoggedIn = true
        UserDefaults.standard.authToken = data.token
    }
    
    func validateSubmit() {
        state.isSubmitDisabled = !(
            state.hasEditedEmail
            && state.isEmailValid
            && state.hasEditedPassword
            && state.isPasswordValid
        )
    }
    
    @MainActor
    func onSubmit() {
        loginUser()
    }
    
    @MainActor
    func loginUser() {
        Task {
            state.isLoading = true
            do {
                var payload = ServicePayload()
                let parameters: [String: Any] = [
                    "email": state.email,
                    "password": state.password
                ]
                payload.setPayload(apiEndPoint: APIConstants.login,
                                   parameters: parameters,
                                   requestType: .post)
                let requestManager = HTTPAsyncManager<LoginResponse>()
                let loginResponse = try await requestManager.generateRequest(payload)
                setLogin(response: loginResponse)
                state.isLoading = false
                
            } catch(let error) {
                print(error.localizedDescription)
                // Show alert or load mock data. Here, we can use mock data, as given in the assessment pdf
                guard let mockData = MockDataManager<LoginResponse>.loadMockData(fileName: Constants.Mock.loginResponse) else { return }
                
                //To simulate server response time
                try await Task.sleep(nanoseconds: Constants.Mock.serverResponseTime)
                state.isLoading = false
                setLogin(response: mockData)
            }
            navigationAction(.next)
        }
    }
    
}

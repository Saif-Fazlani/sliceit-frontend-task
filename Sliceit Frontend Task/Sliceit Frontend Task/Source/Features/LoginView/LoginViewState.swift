//
//  LoginViewState.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import Foundation

final class LoginViewState: ObservableObject {
    
    @Published var tfEmailLabel: String = ""
    @Published var tfEmailPlaceholder: String = ""
    @Published var email: String = ""
    @Published var isEmailValid: Bool = true
    @Published var hasEditedEmail: Bool = false
    @Published var errorMsgEmail: String = ""
    
    @Published var tfPasswordLabel: String = ""
    @Published var tfPasswordPlaceholder: String = ""
    @Published var password: String = ""
    @Published var isPasswordValid: Bool = true
    @Published var hasEditedPassword: Bool = false
    @Published var isTfPasswordSecure: Bool = true
    @Published var errorMsgPassword: String = ""
    
    @Published var btnSubmitTitle: String = ""
    @Published var isSubmitDisabled: Bool = true
    
}

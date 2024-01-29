//
//  LoginView.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

struct LoginView: View {
    
    private let interactor: LoginViewInteractor
    @ObservedObject private var state: LoginViewState
    
    init(state: LoginViewState, interactor: LoginViewInteractor) {
        self.state = state
        self.interactor = interactor
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            //1
            Button(action: {
                interactor.onTapBack()
            }, label: {
                Image(systemName: "arrow.backward")
                    .foregroundStyle(.black)
                    .padding(.bottom, 30)
            })
            .frame(width: 24, height: 24)
            
            //2
            AppTextField(
                text: Binding(
                    get: { state.email },
                    set: { interactor.updateEmail(value: $0) }),
                isSecureField: .constant(false),
                label: state.tfEmailLabel,
                placeholder: state.tfEmailPlaceholder,
                errorMessage: state.errorMsgEmail,
                keyboardType: .emailAddress,
                isValid: state.isEmailValid,
                didChangeText: {
                    state.hasEditedEmail = true
                    interactor.validateSubmit()
                }
            )
            
            //3
            AppTextField(
                text: Binding(
                    get: { state.password },
                    set: { interactor.updatePassword(value: $0) }),
                isSecureField: Binding(
                    get: { state.isTfPasswordSecure },
                    set: { interactor.updatePasswordSecureState(value: $0) }),
                label: state.tfPasswordLabel,
                placeholder: state.tfPasswordPlaceholder,
                errorMessage: state.errorMsgPassword,
                keyboardType: .default,
                isValid: state.isPasswordValid,
                showEyeIcon: true,
                didChangeText: {
                    state.hasEditedPassword = true
                    interactor.validateSubmit()
                }
            )
            
            //4
            Spacer()
            
            //5
            AppButton(title: state.btnSubmitTitle,
                      backgroundColor: .accentColor,
                      borderWidth: 0.0,
                      textColor: .white,
                      isDisabled: state.isSubmitDisabled,
                      onButtonTap: interactor.onSubmit)
            .padding()
            
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            interactor.onAppear()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    private class Interactor: LoginViewInteractor {
        func onAppear() {}
        func onTapBack() {}
        func updateEmail(value: String) {}
        func updatePassword(value: String) {}
        func updatePasswordSecureState(value: Bool) {}
        func validateSubmit() {}
        func onSubmit() {}
    }
    static var previews: some View {
        LoginView(state: LoginViewState(), interactor: Interactor())
    }
}

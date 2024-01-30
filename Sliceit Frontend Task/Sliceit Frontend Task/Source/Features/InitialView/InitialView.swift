//
//  InitialView.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

struct InitialView: View {
    
    private let interactor: InitialViewInteractor
    @ObservedObject private var state: InitialViewState
    
    init(state: InitialViewState, interactor: InitialViewInteractor) {
        self.state = state
        self.interactor = interactor
    }
    
    var body: some View {
        
        ZStack {
            
            //1
            VStack {
                
                //1
                Spacer()
                
                //2
                Text(state.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                
                //3
                Spacer()
                
                //4
                HStack(spacing: 8) {
                    
                    //1
                    AppButton(title: state.btnAboutUsTitle,
                              onButtonTap: interactor.onTapAboutUs)
                    
                    //2
                    AppButton(title: state.btnSignInTitle,
                              onButtonTap: interactor.onTapSignIn)
                }
                .padding()
            }
            
            //2
            if state.isLoading {
                ProgressView()
            }
            
        }
        .onAppear {
            interactor.onAppear()
        }
        .attachingAlert(state: $state.alertState)
    }
}

struct InitialView_Previews: PreviewProvider {
    private class Interactor: InitialViewInteractor {
        func onAppear() {}
        func onTapAboutUs() {}
        func onTapSignIn() {}
    }
    static var previews: some View {
        InitialView(state: InitialViewState(), interactor: Interactor())
    }
}

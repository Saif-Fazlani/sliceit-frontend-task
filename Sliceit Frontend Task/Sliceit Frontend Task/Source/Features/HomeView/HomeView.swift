//
//  HomeView.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    private let interactor: HomeViewInteractor
    @ObservedObject private var state: HomeViewState
    
    init(state: HomeViewState, interactor: HomeViewInteractor) {
        self.state = state
        self.interactor = interactor
    }
    
    var body: some View {
        
        ZStack {
            
            //1
            VStack(alignment: .center) {
                
                //1
                Spacer()
                
                //2
                Text(state.welcomeMessage)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                
                //3
                AppButton(title: state.btnUpdateTitle,
                          backgroundColor: .accentColor,
                          borderWidth: 0.0,
                          textColor: .white,
                          onButtonTap: interactor.onTapUpdate)
                .padding()
                
                //4
                Spacer()
                
                //5
                AppButton(title: state.btnSignOutTitle,
                          onButtonTap: interactor.onTapUpdate)
                .padding()
                
            }
            .padding([.leading, .trailing], 16)
            
            //2
            if state.isLoading {
                ProgressView()
            }
        }
        .onAppear {
            interactor.onAppear()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    private class Interactor: HomeViewInteractor {
        func onAppear() {}
        func onTapUpdate() {}
        func onTapSignOut() {}
    }
    static var previews: some View {
        HomeView(state: HomeViewState(), interactor: Interactor())
    }
}

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
        VStack {
            Text(state.title)
        }
        .onAppear {
            interactor.onAppear()
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    private class Interactor: InitialViewInteractor {
        func onAppear() {}
    }
    static var previews: some View {
        InitialView(state: InitialViewState(), interactor: Interactor())
    }
}

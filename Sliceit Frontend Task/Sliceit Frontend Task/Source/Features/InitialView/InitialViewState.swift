//
//  InitialViewState.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import Foundation

final class InitialViewState: ObservableObject {
    
    @Published var title: String = ""
    @Published var btnAboutUsTitle: String = ""
    @Published var btnSignInTitle: String = ""
}

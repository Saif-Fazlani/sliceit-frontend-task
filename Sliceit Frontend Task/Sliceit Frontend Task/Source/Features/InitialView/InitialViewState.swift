//
//  InitialViewState.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import Foundation

final class InitialViewState: ObservableObject {
    
    enum AlertStateTag {
        case internalError
    }
    
    @Published var isLoading: Bool = false
    @Published var alertState: AlertAppearanceState<AlertStateTag>?
    @Published var title: String = ""
    @Published var btnAboutUsTitle: String = ""
    @Published var btnSignInTitle: String = ""
    
    @Published var infoResponse: InfoResponse = InfoResponse()
}

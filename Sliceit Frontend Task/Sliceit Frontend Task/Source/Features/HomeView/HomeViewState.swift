//
//  HomeViewState.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import Foundation

final class HomeViewState: ObservableObject {
    
    enum AlertStateTag {
        case internalError
    }
    
    @Published var isLoading: Bool = false
    @Published var welcomeMessage: String = ""
    @Published var btnUpdateTitle: String = ""
    @Published var btnSignOutTitle: String = ""
    
    @Published var profileResponse: ProfileResponse = ProfileResponse()
    @Published var authorInfoResponse: AuthorInfoResponse = AuthorInfoResponse()
    @Published var authorQuoteResponse: AuthorQuoteResponse = AuthorQuoteResponse()
}

//
//  HomeViewState.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import Foundation

final class HomeViewState: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var welcomeMessage: String = ""
    @Published var authorText: String = ""
    @Published var btnUpdateTitle: String = ""
    @Published var btnSignOutTitle: String = ""
    @Published var authorName: String = ""
    @Published var authorId: String = ""
    @Published var authorQuote: String = ""
    @Published var isPopupVisible: Bool = false
    @Published var popupTitle: String = ""
    @Published var popupStepOne: String = ""
    @Published var popupStepTwo: String = ""
}

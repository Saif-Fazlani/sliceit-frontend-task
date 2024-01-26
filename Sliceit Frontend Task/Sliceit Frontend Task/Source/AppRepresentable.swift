//
//  AppRepresentable.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

protocol AppRepresentable: UIViewControllerRepresentable where UIViewControllerType == UIViewController {
    func configureOperationalEnvironment() -> Orchestrator
}

extension AppRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        var orchestrator: Orchestrator = configureOperationalEnvironment()
        return orchestrator.bootstrap()
    }

    func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {
        //
    }
}

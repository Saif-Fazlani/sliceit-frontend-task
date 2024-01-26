//
//  AppButton.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

struct AppButton: View {
    
    var title: String
    var onButtonTap: () -> Void
    
    var body: some View {
        Button(action: {
            onButtonTap()
        }, label: {
            Text(title)
        })
        .font(.body)
        .frame(height: 50)
        .fontWeight(.medium)
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(.gray, lineWidth: 1.0)
        )
    }
}

#Preview {
    AppButton(title: "Sign In",
              onButtonTap: {})
}

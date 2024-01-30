//
//  AppButton.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

struct AppButton: View {
    
    var title: String
    var width: CGFloat?
    var backgroundColor: Color = .clear
    var borderWidth: CGFloat = 1.0
    var textColor: Color = .gray
    var isDisabled: Bool = false
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
        .foregroundStyle(textColor)
        .frame(maxWidth: width == nil ? .infinity :  width)
        .background(backgroundColor.opacity(isDisabled ? 0.5 : 1.0))
        .cornerRadius(8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(.gray, lineWidth: borderWidth)
        )
        .disabled(isDisabled)
    }
}

#Preview {
    AppButton(title: "state.btnSubmitTitle",
              width: 250,
              backgroundColor: .accentColor,
              borderWidth: 0.0,
              textColor: .white,
              onButtonTap: {})
}

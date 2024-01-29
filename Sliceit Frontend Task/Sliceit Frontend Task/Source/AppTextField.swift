//
//  AppTextField.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

struct AppTextField: View {
    
    @Binding var text: String
    @Binding var isSecureField: Bool
    
    var label: String
    var placeholder: String
    var errorMessage: String
    var keyboardType: UIKeyboardType
    var isValid: Bool = false
    var showEyeIcon: Bool = false
    var didChangeText: (() -> Void)?
    
    @ViewBuilder
    private var textField: some View {
        if isSecureField {
            SecureField(placeholder,
                        text: $text)
        } else {
            TextField(placeholder,
                      text: $text)
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            //1
            Text(label)
                .font(.body)
                .foregroundColor(.black)
            
            //2
            HStack {
                
                //1
                textField
                    .font(.body)
                    .foregroundColor(.black)
                    .keyboardType(keyboardType)
                    .padding()
                    .frame(height: 50)
                    .submitLabel(.done)
                    .onChange(of: text) {
                        didChangeText?()
                    }
                
                //2
                Spacer()
                
                //3
                if showEyeIcon {
                    Button(action: {
                        isSecureField.toggle()
                    }, label: {
                        Image(systemName: isSecureField ? "eye.slash" : "eye")
                    })
                    .padding()
                    .foregroundStyle(.gray)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(isValid ? .gray : .red, lineWidth: 1.0)
            )
            
            //3
            if !isValid {
                HStack {
                    //1
                    Spacer()
                    
                    //2
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(Color.red)
                        .padding(.trailing, 12)
                }
            }
        }
        
    }
}

#Preview {
    AppTextField(text: .constant("Test"),
                 isSecureField: .constant(true),
                 label: "Email Address",
                 placeholder: "Enter email",
                 errorMessage: "Blah",
                 keyboardType: .default,
                 isValid: true,
                 showEyeIcon: true)
}

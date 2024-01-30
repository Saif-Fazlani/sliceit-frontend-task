//
//  PopupView.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 30/01/2024.
//

import SwiftUI

struct PopupView: View {
    
    var title: String
    var stepOne: String
    var stepTwo: String
    var onCancelTap: () -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24.0) {
            
            //1
            Text(title)
                .font(.title)
                .fontWeight(.medium)
            
            //2
            Text(stepOne)
                .font(.subheadline)
                .fontWeight(.medium)
            
            //3
            Text(stepTwo)
                .font(.subheadline)
                .fontWeight(.medium)
            
            //4
            AppButton(title: "Cancel",
                      width: 150,
                      backgroundColor: .accentColor,
                      borderWidth: 0.0,
                      textColor: .white,
                      onButtonTap: onCancelTap)
        }
        
        .padding()
        
    }
}

#Preview {
    PopupView(title: "Requesting the quote",
    stepOne: "Step 1: Requesting the author..Completed",
    stepTwo: "Step 2: Requesting the quote...",
    onCancelTap: {})
}

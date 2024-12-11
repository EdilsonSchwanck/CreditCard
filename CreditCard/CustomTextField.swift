//
//  CustomTextField.swift
//  CreditCard
//
//  Created by Edilson Borges on 11/12/24.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var hint: String
    @Binding var value: String
    var onChange: () -> ()
    
    @FocusState var isActive: Bool
    
    
    var body: some View {
        VStackLayout(alignment: .leading, spacing: 10){
           Text(title)
                .font(.caption2)
                .foregroundStyle(.gray)
            TextField(hint, text: $value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .contentShape(.rect)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isActive ? .blue : .gray.opacity(0.5), lineWidth: 1.5)
                        .animation(.snappy, value: isActive)
                }
                .focused($isActive)
        }
        .onChange(of: value) { oldValue, newValue in
            onChange()
        }
    }
}


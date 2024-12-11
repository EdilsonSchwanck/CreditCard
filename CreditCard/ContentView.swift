//
//  ContentView.swift
//  CreditCard
//
//  Created by Edilson Borges on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var card: Card = .init()
    @FocusState private var activeField: ActiveField?
    @State private var animateField: ActiveField?
    
    var body: some View {
        VStack(spacing: 15) {
            
            ZStack{
                
                if animateField != .cvv {
                    RadialGradient(
                        gradient: Gradient(colors: [.blue, .purple, .purple]),center: .center,
                        startRadius: 0,
                        endRadius: 450
                    )
                    .clipShape(.rect(cornerRadius: 25))
                    .overlay {
                        CardFrontView()
                    }
                    .transition(.flip)
                    
                }else {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.purple.mix(with: .blue, by: 0.3))
                        .overlay{
                            CardBackView()
                        }
                        .frame(height: 200)
                        .transition(.reverseFlipe)
                }
            }
            .frame(height: 200)
            
            
            
            
            CustomTextField(title: "Numero do Cartão", hint: "", value: $card.number) {
                card.number = String(card.number.group(" ", count: 4).prefix(19))
            }
            .focused($activeField, equals: .number)
            
            
            
            CustomTextField(title: "Nome do Cartão", hint: "", value: $card.name) {
                
            }
            .focused($activeField, equals: .name)
            
            HStack(spacing: 10){
                CustomTextField(title: "Mês", hint: "", value: $card.month) {
                    card.month = String(card.month.prefix(2))
                }
                .focused($activeField, equals: .month)
                
                CustomTextField(title: "Ano", hint: "", value: $card.year) {
                    card.year = String(card.year.prefix(2))
                }
                .focused($activeField, equals: .year)
                
                CustomTextField(title: "CVV", hint: "", value: $card.cvv) {
                    card.cvv = String(card.cvv.prefix(3))
                }
                .focused($activeField, equals: .cvv)
            }
            .keyboardType(.numberPad)
            Spacer(minLength: 0)
        }
        .padding()
        .onChange(of: activeField) { oldValue, newValue in
            withAnimation(.snappy){
                animateField = newValue
            }
        }
    }
    
    @ViewBuilder
    func CardFrontView() -> some View {
        VStack(alignment: .leading, spacing: 15){
            VStack(alignment: .leading, spacing: 4){
                Text("NUMERO DO CARTÃO")
                    .font(.caption)
                Text(String(card.rawCardNumber.dummyText("*", count: 16).prefix(16)).group(" ", count: 4))
                    .font(.title2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 10){
                VStack(alignment: .leading, spacing: 4){
                    Text("NOME DO CARTã0")
                        .font(.caption)
                    Text(card.name.isEmpty ? "SEU NOME" : card.name)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                
                VStack(alignment: .leading, spacing: 4){
                    Text("validade")
                        .font(.caption)
                    
                    HStack(spacing: 4){
                        Text(String(card.month.prefix(2)).dummyText("M", count: 2))
                        Text("/")
                        Text(String(card.year.prefix(2)).dummyText("Y", count: 2))
                    }
                    
                }
                .padding(10)
                
                
            }
        }
        .foregroundStyle(.white)
        .monospaced()
        .contentTransition(.numericText())
        .animation(.snappy, value: card)
        .padding(15)
    }
    
    @ViewBuilder
    func CardBackView() -> some View {
        VStack(spacing: 15){
            Rectangle()
                .fill(.black)
                .frame(height: 45)
                .padding(.horizontal, -15)
                .padding(.top, 10)
            
            VStack(alignment: .trailing, spacing: 6){
                Text("CVV")
                    .font(.caption)
                    .padding(.trailing, 15)
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .frame(height: 45)
                    .overlay(alignment: .trailing) {
                        Text(String(card.cvv.prefix(3)).dummyText("*", count: 3))
                            .foregroundStyle(.black)
                            .padding(.trailing, 15)
                    }
                
            }
            .foregroundStyle(.white)
            .monospaced()
            Spacer(minLength: 0)
            
            
        }
        .padding(15)
        .contentTransition(.numericText())
        .animation(.snappy, value: card)
    }
    
    
}

#Preview {
    ContentView()
}


extension String {
    func group(_ character: Character, count: Int) -> String {
        // Remover qualquer ocorrência existente do caractere separador
        let modifiedString = self.replacingOccurrences(of: String(character), with: "")
        var groupedString = ""
        
        for (index, char) in modifiedString.enumerated() {
            // Adiciona o separador após cada grupo de `count` caracteres
            if index > 0 && index % count == 0 {
                groupedString.append(character)
            }
            groupedString.append(char)
        }
        
        return groupedString
    }
    
    func dummyText(_ character: Character, count: Int) -> String {
        var tempText = self.replacingOccurrences(of: String(character), with: "")
        let remaining = min(max(count - tempText.count, 0), count)
        
        if remaining > 0 {
            tempText.append(String(repeating: character, count: remaining))
        }
        
        return tempText
    }
    
    
}

extension Color {
    func mix(with color: Color, by ratio: CGFloat) -> Color {
        let ratio = max(0, min(ratio, 1)) // Garante que o ratio esteja entre 0 e 1
        
        // Extrai os componentes RGB das cores
        let components1 = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        let components2 = UIColor(color).cgColor.components ?? [0, 0, 0, 1]
        
        let r = (1 - ratio) * components1[0] + ratio * components2[0]
        let g = (1 - ratio) * components1[1] + ratio * components2[1]
        let b = (1 - ratio) * components1[2] + ratio * components2[2]
        let a = (1 - ratio) * components1[3] + ratio * components2[3]
        
        return Color(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}

//
//  Card.swift
//  CreditCard
//
//  Created by Edilson Borges on 11/12/24.
//

import Foundation

struct Card: Hashable {
    var name: String = ""
    var number: String = ""
    var cvv: String = ""
    var month: String = ""
    var year: String = ""
    
    var rawCardNumber: String {
        number.replacingOccurrences(of: " ", with: "")
    }
}

//
//  ProductCardComponentView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 01/08/25.
//
import SwiftUI

struct ProductCardComponentView: View {
    let title: String
    let price: Double
    
    init(_ title: String, _ price: Double) {
        self.title = title
        self.price = price
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(price, format: .currency(code: "BRL"))
        }
    }
}

#Preview {
    ProductCardComponentView("Sapatilha Moleca Infantil", 34.99)
}

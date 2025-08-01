//
//  ResultOfSearchView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import SwiftUI

struct ResultOfSearchView: View {
    @ObservedObject var viewModel: ResultOfSearchViewModel
    
    init(searchText: String) {
        viewModel = ResultOfSearchViewModel(searchText: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.products, id: \.id) { product in
                NavigationLink {
                    DetailView(relativePath: "\(viewModel.searchText)/item-\(product.id)")
                } label: {
                    ProductCardComponentView(product.title, product.price)
                }
            }
            .navigationTitle("Resultado da busca")
        }
        .onAppear(perform: viewModel.getProducts)
    }
}

#Preview {
    ResultOfSearchView(searchText: "cafe")
}

//
//  SearchView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 30/07/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = String()
    @State var navigate: Bool = false
    @ObservedObject private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var resultOfSearch: [String] {
        if searchText.isEmpty {
            return viewModel.categories
        } else {
            return viewModel.categories.filter { $0.contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            Text("O que gostaria de pesquisar hoje?")
                .navigationTitle("Buscar")
                .navigationDestination(isPresented: $navigate) {
                    ResultOfSearchView(searchText: searchText.lowercased())
                }
            
            Spacer()
        }
        .searchable(text: $searchText) {
            ForEach(resultOfSearch, id: \.self) { category in
                Text("Procurando por \(category)?").searchCompletion(category)
            }
        }
        .onAppear {
            viewModel.loadCategories()
        }
        .onSubmit(of: .search, searchAction)
    }
    
    func searchAction() {
        navigate.toggle()
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(isMock: true))
}

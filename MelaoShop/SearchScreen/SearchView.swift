//
//  SearchView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 30/07/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = String()
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
            Text("Looking for \(searchText)")
                .navigationTitle("Search")
            
            Spacer()
        }
        .searchable(text: $searchText) {
            ForEach(resultOfSearch, id: \.self) { category in
                Text("Looking for \(category)?").searchCompletion(category)
            }
        }
        .onAppear {
            viewModel.loadCategories()
        }
        .onSubmit(of: .search, searchAction)
    }
    
    func searchAction() {
        print("Search")
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(isMock: true))
}

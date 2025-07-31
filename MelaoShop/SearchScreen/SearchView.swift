//
//  SearchView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 30/07/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = String()
    @State var categories = [String]()
    
    var resultOfSearch: [String] {
        if searchText.isEmpty {
            return categories
        } else {
            print(searchText)
            return categories.filter { $0.contains(searchText.lowercased()) }
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
        .onAppear(perform: loadCategories)
        .onSubmit(of: .search, searchAction)
    }
    
    func searchAction() {
//        provider.runSearch()
    }
    
    func loadCategories() {
        guard let resourcesURL = Bundle.main.resourceURL?.appendingPathComponent("Mocks") else {
            return
        }
        
        let folderContents = try? FileManager.default.contentsOfDirectory(at: resourcesURL, includingPropertiesForKeys: nil)
        
        let categories = folderContents?.compactMap { $0.lastPathComponent } ?? []
        return self.categories = categories
    }
}

#Preview {
    SearchView()
}

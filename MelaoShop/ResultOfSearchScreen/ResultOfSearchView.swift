//
//  ResultOfSearchView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import SwiftUI

struct ResultOfSearchView: View {
    let searchText: String
    @State var products = [ResultOfSearchModel.Product]()
    
    var body: some View {
        NavigationStack {
            
            Text("Buscar > \(searchText)").multilineTextAlignment(.leading)
            
            List(products, id: \.id) { product in
                NavigationLink {
                    DetailView(relativePath: "\(searchText)/item-\(product.id)")
                } label: {
                    Text(product.title)
                }
            }
            .navigationTitle("Resultado da busca")
        }
        .onAppear {
            DispatchQueue.main.async {
                loadProducts { result in
                    guard let result else {
                        return print("falhou")
                    }
                    self.products = result.results
                }
            }
        }
    }
    
    func loadProducts(completion: @escaping (ResultOfSearchModel?) -> Void) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(searchText)/search-MLA-\(searchText).json") else {
            return completion(nil)
        }
        print(jsonUrl)
        if let data = try? Data(contentsOf: jsonUrl),
           let products = try? JSONDecoder().decode(ResultOfSearchModel.self, from: data){
            return completion(products)
        }
        else {
            return completion(nil)
        }
    }
}

#Preview {
    ResultOfSearchView(searchText: "cafe")
}

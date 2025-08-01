//
//  ResultOfSearchViewModel.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 01/08/25.
//
import SwiftUI

class ResultOfSearchViewModel: ObservableObject {
    let searchText: String
    private let provider: ServiceProviderProtocol
    @Published var products = [ResultOfSearchModel.Product]()
    
    init(searchText: String) {
        self.searchText = searchText
        provider = kIsMock ? ServiceProviderMock() : ServiceProvider()
    }
    
    func getProducts() {
        DispatchQueue.main.async {
            self.provider.getProducts(searchText: self.searchText) { result in
                self.products = result?.results ?? []
            }
        }
    }
}

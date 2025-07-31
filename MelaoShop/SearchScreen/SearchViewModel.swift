//
//  SearchViewModel.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var categories: [String]
    private let provider: ServiceProviderProtocol
    
    init(isMock: Bool) {
        self.categories = []
        self.provider = isMock ? ServiceProviderMock() : ServiceProvider()
    }
    
    func loadCategories() {
        DispatchQueue.main.async {
            self.provider.loadCategories { result in
                self.categories = result
            }
        }
    }
}



//
//  SearchViewModel.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var categories: [String]
    @Published var hasError: Bool = false
    private let path: String
    private let provider: ServiceProviderProtocol
    
    init(path: String = "Mocks") {
        self.categories = []
        self.path = path
        self.provider = kIsMock ? ServiceProviderMock.shared : ServiceProvider.shared
    }
    
    func loadCategories() {
        DispatchQueue.main.async {
            self.provider.getCategories(path: self.path) { result in
                switch result {
                case .success(let categories):
                    self.hasError = false
                    return self.categories = categories
                case .failure(_):
                    return self.hasError = true
                }
            }
        }
    }
}



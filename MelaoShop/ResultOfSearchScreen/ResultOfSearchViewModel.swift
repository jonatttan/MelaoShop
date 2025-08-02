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
    @Published var hasError: Bool = false
    private var errorType: NetworkError?
    
    init(searchText: String) {
        self.searchText = searchText
        provider = kIsMock ? ServiceProviderMock.shared : ServiceProvider.shared
    }
    
    var errorMessage: String {
        switch errorType {
        case .noData:
            return "Nenhum produto encontrado."
        default:
            return "Erro ao buscar produtos, tente novamente mais tarde."
        }
    }
    
    func getProducts() {
        DispatchQueue.main.async {
            self.provider.getProducts(searchText: self.searchText) { result in
                switch result {
                case .success(let searchResult):
                    self.hasError = false
                    return self.products = searchResult.results
                case .failure(let error):
                    self.hasError = true
                    return self.errorType = error
                }
            }
        }
    }
}

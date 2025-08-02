//
//  DetailViewModel.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var mainDetail: DetailModel.MainDetail?
    @Published var descriptionDetail: DetailModel.DescriptionDetail?
    @Published var categoryDetail: DetailModel.CategoryDetail?
    private let relativePath: String
    private let provider: ServiceProviderProtocol
    @Published var errorType: NetworkError?
    
    init(relativePath: String) {
        self.provider = kIsMock ? ServiceProviderMock.shared : ServiceProvider.shared
        self.relativePath = relativePath
    }
    
    var errorMessage: String {
        switch errorType {
        case .noData:
            return "Erro ao obter dados do produto"
        default:
            return "Erro ao comunicar com servidor, tente novamente mais tarde"
        }
    }
    
    var pictureUrl: String {
        return mainDetail?.pictures.first?.secureUrl ?? String()
    }
    
    var pictureSizeHeight: CGFloat {
        let sizeArray = mainDetail?.pictures.first?.size.components(separatedBy: "x")
        let height = Double(sizeArray?.last ?? String()) ?? 0
        return CGFloat(height)
    }
    
    var title: String {
        return mainDetail?.title ?? String()
    }
    
    var price: Double {
        return mainDetail?.price ?? 0
    }
    
    var attributes: [DetailModel.MainDetail.Attributes] {
        guard let attributes = mainDetail?.attributes else { return [] }
        return attributes
    }
    
    var saleTerms: [DetailModel.MainDetail.SaleTerms] {
        guard let saleTerms = mainDetail?.saleTerms else { return [] }
        return saleTerms
    }
    
    var description: String {
        return descriptionDetail?.plainText ?? String()
    }
    
    var productPath: String {
        let path = categoryDetail?.pathFromRoot.compactMap { $0.name }
        let joined = path?.joined(separator: " > ") ?? String()
        return joined
    }
    
    func getDetail() {
        DispatchQueue.main.async {
            self.provider.getMainDetail(from: self.relativePath) { result in
                switch result {
                case .success(let mainDetail):
                    self.errorType = nil
                    return self.mainDetail = mainDetail
                case .failure(let error):
                    return self.errorType = error
                }
            }
        }
        
        DispatchQueue.main.async {
            self.provider.getDescriptionDetail(from: self.relativePath) { result in
                switch result {
                case .success(let descriptionDetail):
                    return self.descriptionDetail = descriptionDetail
                case .failure(_):
                    return
                }
            }
        }
        
        DispatchQueue.main.async {
            self.provider.getCategoryDetail(from: self.relativePath) { result in
                switch result {
                case .success(let categoryDetail):
                    return self.categoryDetail = categoryDetail
                case .failure(_):
                    return
                }
            }
        }
    }
}

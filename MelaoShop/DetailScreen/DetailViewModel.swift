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
    
    init(relativePath: String) {
        self.provider = kIsMock ? ServiceProviderMock() : ServiceProvider()
        self.relativePath = relativePath
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
            self.provider.getMainDetail(from: self.relativePath) { mainDetail in
                self.mainDetail = mainDetail
            }
        }
        
        DispatchQueue.main.async {
            self.provider.getDescriptionDetail(from: self.relativePath) { descriptionDetail in
                self.descriptionDetail = descriptionDetail
            }
        }
        
        DispatchQueue.main.async {
            self.provider.getCategoryDetail(from: self.relativePath) { categoryDetail in
                self.categoryDetail = categoryDetail
            }
        }
    }
}

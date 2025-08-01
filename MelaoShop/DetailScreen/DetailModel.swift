//
//  DetailModel.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//

// imagem - item-MLB3128412969.json { pictures[] }

// Caminho - item-MLB3128412969-category.json { path_from_root [] }
// Quantidade maxima de compra - item-MLB3128412969.json
// Tempo de garantia - item-MLB3128412969.json
// Tipo de garantia - item-MLB3128412969.json

import Foundation

struct DetailModel: Decodable {
    let mainDetail: MainDetail
    let description: DescriptionDetail
    let category: CategoryDetail
    
    struct MainDetail: Decodable {
        let title: String
        let price: Double
        let attributes: [Attributes]
        let saleTerms: [SaleTerms]
        let pictures: [Picture]
        
        struct Attributes: Decodable, Identifiable {
            let id: String
            let name: String
            let valueName: String
        }
        
        struct SaleTerms: Decodable, Identifiable {
            let id: String
            let name: String
            let valueName: String
        }
        
        struct Picture: Decodable {
            let secureUrl: String
            let size: String
        }
    }
    
    struct DescriptionDetail: Decodable {
        let plainText: String
    }
    
    struct CategoryDetail: Decodable {
        let pathFromRoot: [CategoryDetailElement]
        
        struct CategoryDetailElement: Decodable {
            let id: String
            let name: String
        }
    }
}

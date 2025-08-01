//
//  ResultOfSearchModel.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import Foundation

struct ResultOfSearchModel: Decodable{
    let results: [Product]
    
    struct Product: Decodable {
        let id: String
        let title: String
        let price: Double
    }
}

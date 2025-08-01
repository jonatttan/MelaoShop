//
//  ServiceProvider.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import Foundation

protocol ServiceProviderProtocol {
    func getCategories(completion: @escaping ([String]) -> Void)
    func getProducts(searchText: String, completion: @escaping (ResultOfSearchModel?) -> Void)
    func getMainDetail(from relativePath: String, completion: @escaping (DetailModel.MainDetail?) -> Void)
    func getDescriptionDetail(from relativePath: String, completion: @escaping (DetailModel.DescriptionDetail?) -> Void)
    func getCategoryDetail(from relativePath: String, completion: @escaping (DetailModel.CategoryDetail?) -> Void)
}

class ServiceProvider: ServiceProviderProtocol {
    func getCategories(completion: @escaping ([String]) -> Void) {
        completion([])
    }
    func getProducts(searchText: String, completion: @escaping (ResultOfSearchModel?) -> Void) {
        completion(nil)
    }
    
    func getMainDetail(from relativePath: String, completion: @escaping (DetailModel.MainDetail?) -> Void) {
        completion(nil)
    }
    
    func getDescriptionDetail(from relativePath: String, completion: @escaping (DetailModel.DescriptionDetail?) -> Void) {
        completion(nil)
    }
    
    func getCategoryDetail(from relativePath: String, completion: @escaping (DetailModel.CategoryDetail?) -> Void) {
        completion(nil)
    }
}

class ServiceProviderMock: ServiceProviderProtocol {
    // MARK: - Search screen
    func getCategories(completion: @escaping ([String]) -> Void) {
        guard let resourcesURL = Bundle.main.resourceURL?.appendingPathComponent("Mocks") else {
            return completion([])
        }
        
        let folderContents = try? FileManager.default.contentsOfDirectory(at: resourcesURL, includingPropertiesForKeys: nil)
        let categories = folderContents?.compactMap { $0.lastPathComponent } ?? []
        return completion(categories)
    }
    
    // MARK: - ResultOfSearch screen
    func getProducts(searchText: String, completion: @escaping (ResultOfSearchModel?) -> Void) {
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
    
    // MARK: - Detail screen
    func getMainDetail(from relativePath: String, completion: @escaping (DetailModel.MainDetail?) -> Void) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(relativePath).json") else {
            return completion(nil)
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = try? Data(contentsOf: jsonUrl),
           let productMainDetail = try? jsonDecoder.decode(DetailModel.MainDetail.self, from: data) {
            debugPrint(productMainDetail)
            return completion(productMainDetail)
        } else {
            return completion(nil)
        }
    }
    
    func getDescriptionDetail(from relativePath: String, completion: @escaping (DetailModel.DescriptionDetail?) -> Void) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(relativePath)-description.json") else {
            return completion(nil)
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = try? Data(contentsOf: jsonUrl),
           let productDescriptionDetail = try? jsonDecoder.decode(DetailModel.DescriptionDetail.self, from: data) {
            return completion(productDescriptionDetail)
        } else {
            return completion(nil)
        }
    }
    
    func getCategoryDetail(from relativePath: String, completion: @escaping (DetailModel.CategoryDetail?) -> Void) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(relativePath)-category.json") else {
            return completion(nil)
        }
        print(jsonUrl)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = try? Data(contentsOf: jsonUrl),
           let productCategoryDetail = try? jsonDecoder.decode(DetailModel.CategoryDetail.self, from: data) {
            return completion(productCategoryDetail)
        } else {
            return completion(nil)
        }
    }
}

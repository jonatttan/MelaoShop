//
//  ServiceProvider.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import Foundation
enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case noData
    case otherError(Error)
}

protocol ServiceProviderProtocol {
    func getCategories(path: String, completion: @escaping ((Result<[String], NetworkError>) -> Void))
    func getProducts(searchText: String,
                     completion: @escaping ((Result<ResultOfSearchModel, NetworkError>) -> Void))
    func getMainDetail(from relativePath: String,
                       completion: @escaping ((Result<DetailModel.MainDetail, NetworkError>) -> Void))
    func getDescriptionDetail(from relativePath: String,
                              completion: @escaping ((Result<DetailModel.DescriptionDetail, NetworkError>) -> Void))
    func getCategoryDetail(from relativePath: String,
                           completion: @escaping ((Result<DetailModel.CategoryDetail, NetworkError>) -> Void))
}

class ServiceProvider: ServiceProviderProtocol {
    static let shared: ServiceProviderProtocol = ServiceProvider()
    
    private init() { }
    
    func getCategories(path: String, completion: @escaping ((Result<[String], NetworkError>) -> Void)) {
        completion(.failure(.noData))
    }
    func getProducts(searchText: String,
                     completion: @escaping ((Result<ResultOfSearchModel, NetworkError>) -> Void)) {
        completion(.failure(.invalidURL))
    }
    
    func getMainDetail(from relativePath: String,
                       completion: @escaping ((Result<DetailModel.MainDetail, NetworkError>) -> Void)) {
        completion(.failure(.invalidURL))
    }
    
    func getDescriptionDetail(from relativePath: String,
                              completion: @escaping ((Result<DetailModel.DescriptionDetail, NetworkError>) -> Void)) {
        completion(.failure(.invalidURL))
    }
    
    func getCategoryDetail(from relativePath: String,
                           completion: @escaping ((Result<DetailModel.CategoryDetail, NetworkError>) -> Void)) {
        completion(.failure(.invalidURL))
    }
}

final class ServiceProviderMock: ServiceProviderProtocol {
    static let shared: ServiceProviderProtocol = ServiceProviderMock()
    private let jsonDecoder = JSONDecoder()
    
    private init() {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Search screen
    func getCategories(path: String, completion: @escaping ((Result<[String], NetworkError>) -> Void)) {
        guard let resourcesURL = Bundle.main.resourceURL?.appendingPathComponent(path),
              let folderContents = try? FileManager.default.contentsOfDirectory(at: resourcesURL, includingPropertiesForKeys: nil) else {
            return completion(.failure(.invalidURL))
        }
        
        let categories = folderContents.compactMap { $0.lastPathComponent }
        guard !categories.isEmpty else {
            return completion(.failure(.noData))
        }
        
        return completion(.success(categories))
    }
    
    // MARK: - ResultOfSearch screen
    func getProducts(searchText: String, completion: @escaping ((Result<ResultOfSearchModel, NetworkError>) -> Void)) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(searchText)/search-MLA-\(searchText).json") else {
            return completion(.failure(.invalidURL))
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            return completion(.failure(.noData))
        }
        
        guard let products = try? jsonDecoder.decode(ResultOfSearchModel.self, from: data) else {
            return completion(.failure(.decodingFailed))
        }
        
        return completion(.success(products))
    }
    
    // MARK: - Detail screen
    func getMainDetail(from relativePath: String,
                       completion: @escaping ((Result<DetailModel.MainDetail, NetworkError>) -> Void)) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(relativePath).json") else {
            return completion(.failure(.invalidURL))
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            return completion(.failure(.noData))
        }
        
        guard let productMainDetail = try? jsonDecoder.decode(DetailModel.MainDetail.self, from: data) else {
            return completion(.failure(.decodingFailed))
        }
        
        return completion(.success(productMainDetail))
    }
    
    func getDescriptionDetail(from relativePath: String,
                              completion: @escaping ((Result<DetailModel.DescriptionDetail, NetworkError>) -> Void)) {
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(relativePath)-description.json") else {
            return completion(.failure(.invalidURL))
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            return completion(.failure(.noData))
        }
        
        guard let productDescriptionDetail = try? jsonDecoder.decode(DetailModel.DescriptionDetail.self, from: data) else {
            return completion(.failure(.decodingFailed))
        }
        
        return completion(.success(productDescriptionDetail))
    }
    
    func getCategoryDetail(from relativePath: String,
                           completion: @escaping ((Result<DetailModel.CategoryDetail, NetworkError>) -> Void)) {
        
        guard let jsonUrl = Bundle.main.resourceURL?.appendingPathComponent("Mocks/\(relativePath)-description.json") else {
            return completion(.failure(.invalidURL))
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            return completion(.failure(.noData))
        }
        
        guard let productCategoryDetail = try? jsonDecoder.decode(DetailModel.CategoryDetail.self, from: data) else {
            return completion(.failure(.decodingFailed))
        }
        
        return completion(.success(productCategoryDetail))
    }
}

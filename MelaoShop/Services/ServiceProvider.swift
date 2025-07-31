//
//  ServiceProvider.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import Foundation

protocol ServiceProviderProtocol {
    func loadCategories(completion: @escaping ([String]) -> Void)
}

class ServiceProvider: ServiceProviderProtocol {
    func loadCategories(completion: @escaping ([String]) -> Void) {
        completion([])
    }
}

class ServiceProviderMock: ServiceProviderProtocol {
    func loadCategories(completion: @escaping ([String]) -> Void) {
        guard let resourcesURL = Bundle.main.resourceURL?.appendingPathComponent("Mocks") else {
            return completion([])
        }
        
        let folderContents = try? FileManager.default.contentsOfDirectory(at: resourcesURL, includingPropertiesForKeys: nil)
        
        let categories = folderContents?.compactMap { $0.lastPathComponent } ?? []
        return completion(categories)
    }
}

//
//  ServiceProviderTest.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 01/08/25.
//

import XCTest
@testable import MelaoShop

final class ServiceProviderTest: XCTestCase {
    var sut: ServiceProviderProtocol!
    
    override func setUp() {
        super.setUp()
        sut = ServiceProviderMock.shared
    }
    
    override func tearDown()  {
        sut = nil
        super.tearDown()
    }
    
    func testGetCategories_success() {
        let expectation = expectation(description: "Load categories")
        sut.getCategories(path: "Mocks") { result in
            switch result {
            case .success(let categories):
                XCTAssertFalse(categories.isEmpty)
            case .failure:
                XCTFail("Failure to load categories")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetProducts_success() {
        let expectation = expectation(description: "Load products")
        sut.getProducts(searchText: "cafe") { result in
            switch result {
            case .success(let model):
                XCTAssertFalse(model.results.isEmpty)
            case .failure:
                XCTFail("Failure to load products")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMainDetail_success() {
        let expectation = expectation(description: "Load main detail")
        sut.getMainDetail(from: "cafe/item-MLB3998144995") { result in
            switch result {
            case .success(let detail):
                XCTAssertFalse(detail.title.isEmpty)
                XCTAssertFalse(detail.attributes.isEmpty)
            case .failure:
                XCTFail("Failure to load main detail")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetDescriptionDetail_success() {
        let expectation = expectation(description: "Carregou descrição")
        sut.getDescriptionDetail(from: "cafe/item-MLB3998144995") { result in
            switch result {
            case .success(let desc):
                XCTAssertFalse(desc.plainText.isEmpty)
            case .failure:
                XCTFail("Falha ao carregar descrição")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

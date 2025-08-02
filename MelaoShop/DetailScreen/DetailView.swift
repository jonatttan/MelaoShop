//
//  DetailView.swift
//  MelaoShop
//
//  Created by Jonattan Sousa on 31/07/25.
//
import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    init(relativePath: String) {
        self.viewModel = DetailViewModel(relativePath: relativePath)
    }
    
    var body: some View {
        VStack {
            if viewModel.errorType != nil {
                Text(viewModel.errorMessage)
                    .padding()
            } else {
                detailViewElement
            }
        }
        .onAppear(perform: viewModel.getDetail)
    }
    
    @ViewBuilder
    var detailViewElement: some View {
        List {
            image
            
            Text(viewModel.title)
            LabeledContent("Preço") {
                Text(viewModel.price, format: .currency(code: "BRL"))
            }
            
            LabeledContent("Descrição", value: viewModel.description)
            LabeledContent("Caminho na loja", value: viewModel.productPath)
            
            attributesInfo
            
            termsInfo
        }
    }
    
    @ViewBuilder
    var image: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.pictureUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    Text("Sem imagem")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: viewModel.pictureSizeHeight)
        }
    }
    
    @ViewBuilder
    var attributesInfo: some View {
        if !viewModel.attributes.isEmpty {
            VStack {
                ForEach(viewModel.attributes, id: \.id) { attribute in
                    LabeledContent(attribute.name, value: attribute.valueName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    @ViewBuilder
    var termsInfo: some View {
        if !viewModel.saleTerms.isEmpty {
            VStack {
                ForEach(viewModel.saleTerms, id: \.id) { term in
                    LabeledContent(term.name, value: term.valueName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    DetailView(relativePath: "cafe/item-MLB3998144995")
}

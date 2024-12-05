//
//  RepositoryModel.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

struct RepositoryModel {
    var title: String
    var subtitle: String
    var iconUrl: URL?
}

// from GitHubResponse
extension RepositoryModel {
    static func make(from response: GitHubResponse.RepositoryResponse) -> Self {
        return Self.init(
            title: response.owner.login + "/" + response.name,
            subtitle: response.description ?? "без описания",
            iconUrl: response.owner.avatar_url.flatMap(URL.init(string:))
        )
    }
    
    static func make(from response: GitHubResponse) -> [RepositoryModel] {
        response.items.map(RepositoryModel.make(from:))
    }
}

// from storage
extension RepositoryModel {
    static func make(from storageModel: [RepositoryStorageModel]) -> [RepositoryModel] {
        storageModel.map {
            RepositoryModel.init(title: $0.title, subtitle: $0.subtitle, iconUrl: $0.imageUrl)
        }
    }
}

//
//  GitHubResponse.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

struct GitHubResponse: Codable {
    var items: [RepositoryResponse]
}

extension GitHubResponse {
    struct RepositoryResponse: Codable {
        var name: String
        var owner: OwnerResponse
        var description: String?
    }
}

extension GitHubResponse.RepositoryResponse {
    struct OwnerResponse: Codable {
        var login: String
        var avatar_url: String?
    }
}

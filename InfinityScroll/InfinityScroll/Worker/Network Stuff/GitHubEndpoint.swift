//
//  GitHubEndpoint.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

enum GitHubEndpoint: Endpoint {
    case repositories(
        q: String,
        page: Int,
        perPage: Int
    )
    
    var baseUrl: String {
        return "https://api.github.com/search"
    }

    var compositePath: String {
        switch self {
        case .repositories:
            return "/repositories"
        }
    }

    var headers: [String: String] { [:] }

    var parameters: [String: String]? {
        var result: [String: String] = [:]
        switch self {
        case .repositories(let q, let page, let perPage):
            result = [
                "q": "\(q)",
                "page": "\(page)",
                "per_page": "\(perPage)"
            ]
        }

        return result
    }
}

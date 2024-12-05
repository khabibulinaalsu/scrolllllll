//
//  Endpoint.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var compositePath: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
    var url: URL? { get }
}

extension Endpoint {    
    var url: URL? {
        guard
            let base = URL(string: baseUrl),
            var components = URLComponents(url: base, resolvingAgainstBaseURL: false)
        else {
            return nil
        }

        let queryItems = parameters?.map {
            URLQueryItem(name: $0, value: $1)
        }

        components.path += compositePath
        components.queryItems = queryItems

        return components.url
    }
}

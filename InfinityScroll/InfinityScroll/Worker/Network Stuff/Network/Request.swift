//
//  Request.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

struct Request {
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case options = "OPTIONS"
    }
    
    var url: URL?
    var headers: [String: String]
    var method: RequestMethod
    let body: Data?
    var timeoutInterval: TimeInterval

    init(
        endpoint: Endpoint,
        method: Request.RequestMethod = .get,
        body: Data? = nil,
        timeoutInterval: TimeInterval = 60
    ) {
        self.url = endpoint.url
        self.headers = endpoint.headers
        self.method = method
        self.body = body
        self.timeoutInterval = timeoutInterval
    }

    init(
        url: URL?,
        headers: [String: String] = [:],
        method: Request.RequestMethod = .get,
        body: Data? = nil,
        timeoutInterval: TimeInterval = 60
    ) {
        self.url = url
        self.headers = headers
        self.method = method
        self.body = body
        self.timeoutInterval = timeoutInterval
    }
}

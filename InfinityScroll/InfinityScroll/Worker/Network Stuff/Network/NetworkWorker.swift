//
//  Networking.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

// For dependency injections and custom networkers
// Example: Service that allows switching to testing environments
protocol NetworkingLogic {
    typealias Response = ((_ response: Result<Networking.ServerResponse, Error>) -> Void)

    func executeRequest(with request: Request, completion: @escaping Response)
}

enum Networking {
    struct ServerResponse {
        var data: Data?
        var response: URLResponse?
    }
}

final class BaseNetworkWorker: NetworkingLogic {
    func executeRequest(with request: Request, completion: @escaping Response) {
        guard let urlRequest = convert(request) else {
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(Networking.ServerResponse(data: data, response: response)))
        }

        task.resume()
    }

    private func convert(_ request: Request) -> URLRequest? {
        guard let url = request.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = request.timeoutInterval

        return urlRequest
    }
}

//
//  GitHubWorker.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

protocol GitHubWorker {
    func fetchRepositories(completion: @escaping (Result<[RepositoryModel], Error>) -> Void)
    func loadRepositories(completion: @escaping (Result<[RepositoryModel], Error>) -> Void)
    func deleteRepository(by index: Int)
    func editRepository(at index: Int, new: RepositoryModel)
    func addRepositories(_ new: [RepositoryModel])
}

final class GitHubWorkerImpl: GitHubWorker {
    private let networkManager: NetworkingLogic
    private let storageManager: StorageLogic
    private let decoder: JSONDecoder = JSONDecoder()
    private var page: Int {
        didSet {
            UserDefaults.standard.setValue(page, forKey: "page")
        }
    }

    init(networkManager: NetworkingLogic, storageManager: StorageLogic) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        self.page = UserDefaults.standard.integer(forKey: "page")
    }

    func fetchRepositories(completion: @escaping (Result<[RepositoryModel], Error>) -> Void) {
        print("try load data from api")
        page += 1
        let endpoint = GitHubEndpoint.repositories(q: "s", page: page, perPage: 100)
        fetch(request: Request(endpoint: endpoint, timeoutInterval: 5), completion: completion)
    }
    
    func loadRepositories(completion: @escaping (Result<[RepositoryModel], any Error>) -> Void) {
        print("try load data from storage")
        Task {
            completion(.success(RepositoryModel.make(from: await storageManager.repositories)))
        }
    }
    
    @MainActor 
    func deleteRepository(by index: Int) {
        storageManager.deleteRepository(by: index)
    }
    
    @MainActor
    func editRepository(at index: Int, new: RepositoryModel) {
        storageManager.editRepository(at: index, new: new)
    }
    
    @MainActor 
    func addRepositories(_ new: [RepositoryModel]) {
        storageManager.addRepositories(new: new)
    }

    private func fetch(request: Request, completion: @escaping (Result<[RepositoryModel], Error>) -> Void) {
        networkManager.executeRequest(with: request) { [weak self] response in
            switch response {
            case .success(let serverResponse):
                guard
                    let self,
                    let data = serverResponse.data
                else {
                    completion(.success([]))
                    return
                }

                do {
                    let decoded = try self.decoder.decode(GitHubResponse.self, from: data)
                    completion(.success(RepositoryModel.make(from: decoded)))
                } catch(let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

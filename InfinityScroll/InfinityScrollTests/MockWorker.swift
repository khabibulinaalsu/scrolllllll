//
//  MockWorker.swift
//  InfinityScrollTests
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import XCTest
import Foundation
@testable import InfinityScroll

final class MockWorker: GitHubWorker {
    var loadRepositoriesWasCalled = false
    var fetchRepositoriesWasCalled = false
    var repos: [InfinityScroll.RepositoryModel] = []
    
    func fetchRepositories(completion: @escaping (Result<[InfinityScroll.RepositoryModel], any Error>) -> Void) {
        fetchRepositoriesWasCalled = true
        completion(.success(repos))
    }
    
    func loadRepositories(completion: @escaping (Result<[InfinityScroll.RepositoryModel], any Error>) -> Void) {
        loadRepositoriesWasCalled = true
        completion(.success(repos))
    }
    
    func deleteRepository(by index: Int) {
        repos.remove(at: index)
    }
    
    func editRepository(at index: Int, new: InfinityScroll.RepositoryModel) {
        repos[index] = new
    }
    
    func addRepositories(_ new: [InfinityScroll.RepositoryModel]) {
        repos += new
    }
    
}

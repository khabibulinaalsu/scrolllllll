//
//  MockPresenter.swift
//  InfinityScrollTests
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import XCTest
import Foundation
@testable import InfinityScroll

final class MockPresenter: GitHubPresenter {
    var repos: [InfinityScroll.RepositoryModel] = []
    
    func addRepositoriesToView(_ repos: [InfinityScroll.RepositoryModel]) {
        self.repos += repos
    }
    
    func deleteRepositoryFromView(by index: Int) {
        repos.remove(at: index)
    }
    
    func editRepositoryOnView(at index: Int, new repo: InfinityScroll.RepositoryModel) {
        repos[index] = repo
    }
}

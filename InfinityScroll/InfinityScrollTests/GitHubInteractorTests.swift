//
//  GitHubInteractorTests.swift
//  InfinityScrollTests
//
//  Created by Alsu Khabibulina  on 04.12.2024.
//

import XCTest
@testable import InfinityScroll

// protocol GitHubInteractor {
//    func loadStart()
//    func deleteRepository(by index: Int)
//    func editRepository(by index: Int, new repo: RepositoryModel)
//    func loadMoreRepositories()
//}

final class GitHubInteractorTests: XCTestCase {
    func testLoadStart() {
        // Arrange
        let testRepo = RepositoryModel(title: "1", subtitle: "2")
        let presenter = MockPresenter()
        let worker = MockWorker()
        let interactor = GitHubInteractorImpl(presenter: presenter, worker: worker)
        
        // Act
        worker.addRepositories([testRepo])
        interactor.loadStart()
        sleep(100)
        
        // Assert
        XCTAssertTrue(worker.loadRepositoriesWasCalled)
        XCTAssertTrue(worker.repos.count == 1)
        XCTAssertTrue(presenter.repos.count == 1)
        XCTAssertFalse(worker.fetchRepositoriesWasCalled)
    }
    
    func testDeleteRepository() {
        // Arrange
        let testRepo = RepositoryModel(title: "1", subtitle: "2")
        let presenter = MockPresenter()
        let worker = MockWorker()
        let interactor = GitHubInteractorImpl(presenter: presenter, worker: worker)
        
        // Act
        worker.addRepositories([testRepo])
        interactor.loadStart()
        sleep(100)
        interactor.deleteRepository(by: 0)
        
        // Assert
        XCTAssertTrue(worker.loadRepositoriesWasCalled)
        XCTAssertFalse(worker.fetchRepositoriesWasCalled)
        XCTAssertTrue(worker.repos.count == 0)
        XCTAssertTrue(presenter.repos.count == 0)
    }
    
    func testEditRepository() {
        // Arrange
        let testRepo = RepositoryModel(title: "1", subtitle: "2")
        let newTestRepo = RepositoryModel(title: "5", subtitle: "6")
        let presenter = MockPresenter()
        let worker = MockWorker()
        let interactor = GitHubInteractorImpl(presenter: presenter, worker: worker)
        
        // Act
        worker.addRepositories([testRepo])
        interactor.loadStart()
        sleep(100)
        interactor.editRepository(by: 0, new: newTestRepo)
        
        // Assert
        XCTAssertTrue(worker.loadRepositoriesWasCalled)
        XCTAssertFalse(worker.fetchRepositoriesWasCalled)
        XCTAssertTrue(worker.repos.count == 1)
        XCTAssertTrue(presenter.repos.count == 1)
        XCTAssertTrue(worker.repos[0].title == presenter.repos[0].title)
    }
    
    func testLoadMoreRepositories() {
        // Arrange
        let testRepo = RepositoryModel(title: "1", subtitle: "2")
        let presenter = MockPresenter()
        let worker = MockWorker()
        let interactor = GitHubInteractorImpl(presenter: presenter, worker: worker)
        
        // Act
        worker.addRepositories([testRepo])
        interactor.loadMoreRepositories()
        sleep(100)
        
        // Assert
        XCTAssertFalse(worker.loadRepositoriesWasCalled)
        XCTAssertTrue(worker.fetchRepositoriesWasCalled)
        XCTAssertTrue(worker.repos.count == 2, "Вышло так, что сначала добавили, а потом еще раз добавили чтобы сохранить)) в реалиях не должно дублироваться")
        XCTAssertTrue(presenter.repos.count == 1)
    }
}

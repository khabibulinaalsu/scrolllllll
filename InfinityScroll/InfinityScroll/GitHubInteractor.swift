//
//  GitHubInteractor.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

protocol GitHubInteractor {
    func loadStart()
    func deleteRepository(by index: Int)
    func editRepository(by index: Int, new repo: RepositoryModel)
    func loadMoreRepositories()
}

final class GitHubInteractorImpl: GitHubInteractor {
    private let presenter: GitHubPresenter
    private let worker: GitHubWorker
    private var loadMoreIsAvailable = true
    
    init(presenter: GitHubPresenter, worker: GitHubWorker) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func loadStart() {
        worker.loadRepositories { [weak self] result in
            print("have completion from loading from storage")
            switch result {
            case .success(let response):
                if response.count > 0 {
                    print("success from storage")
                    self?.presenter.addRepositoriesToView(response)
                } else {
                    self?.loadMoreRepositories()
                }
            default:
                print("oopsi, have some troubles with storage")
                self?.loadMoreIsAvailable = false
            }
        }
    }
    
    func deleteRepository(by index: Int) {
        worker.deleteRepository(by: index)
        presenter.deleteRepositoryFromView(by: index)
    }
    
    func editRepository(by index: Int, new repo: RepositoryModel) {
        worker.editRepository(at: index, new: repo)
        presenter.editRepositoryOnView(at: index, new: repo)
    }
    
    func loadMoreRepositories() {
        if loadMoreIsAvailable {
            print("try to load repos from internet")
            // Вот бы еще проверять на дубликаты, но это уже совсем другая история
            worker.fetchRepositories { [weak self] result in
                print("have completion from loading from internet")
                switch result {
                case .success(let response):
                    if response.count > 0 {
                        self?.presenter.addRepositoriesToView(response)
                        self?.worker.addRepositories(response)
                    } else {
                        self?.loadMoreIsAvailable = false
                    }
                // По-хорошему нужно обработать ошибки, но мы будем считать,
                // что ошибка произойдет в случае того что репозитории закончатся(лимит апи - 1000)
                // и больше не будем пытаться загрузить еще
                default:
                    print("oopsi, have some troubles with internet")
                    self?.loadMoreIsAvailable = false
                }
            }
        }
    }
}

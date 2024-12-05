//
//  GitHubPresenter.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation

protocol GitHubPresenter {
    func addRepositoriesToView(_ repos: [RepositoryModel])
    func deleteRepositoryFromView(by index: Int)
    func editRepositoryOnView(at index: Int, new repo: RepositoryModel)
}

final class GitHubPresenterImpl: GitHubPresenter {
    weak var view: GitHubViewController?
    
    func addRepositoriesToView(_ repos: [RepositoryModel]) {
        view?.model += repos
        refresh()
    }
    
    func deleteRepositoryFromView(by index: Int) {
        view?.model.remove(at: index)
        refresh()
    }
    
    func editRepositoryOnView(at index: Int, new repo: RepositoryModel) {
        view?.model[index] = repo
        refresh()
    }
    
    private func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.tableView.reloadData()
        }
    }
}

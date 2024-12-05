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
    
    @MainActor
    func addRepositoriesToView(_ repos: [RepositoryModel]) {
        view?.model += repos
        refresh()
    }
    
    @MainActor
    func deleteRepositoryFromView(by index: Int) {
        view?.model.remove(at: index)
        refresh()
    }
    
    @MainActor 
    func editRepositoryOnView(at index: Int, new repo: RepositoryModel) {
        view?.model[index] = repo
        refresh()
    }
    
    @MainActor
    private func refresh() {
        view?.tableView.reloadData()
    }
}

//
//  AppBuilder.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import UIKit

enum AppBuilder {
    @MainActor 
    static func build() -> UIViewController {
        let networkManager = BaseNetworkWorker()
        let storageManager = StorageWorker()
        let worker = GitHubWorkerImpl(networkManager: networkManager, storageManager: storageManager)
        let presenter = GitHubPresenterImpl()
        let interactor = GitHubInteractorImpl(presenter: presenter, worker: worker)
        let viewController = GitHubViewController(interactor: interactor)
        presenter.view = viewController
        return viewController
    }
}

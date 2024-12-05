//
//  StorageWorker.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import Foundation
import SwiftData

@MainActor
protocol StorageLogic {
    var repositories: [RepositoryStorageModel] { get }
    func deleteRepository(by index: Int)
    func editRepository(at index: Int, new: RepositoryModel)
    func addRepositories(new: [RepositoryModel])
}

@MainActor
final class StorageWorker: StorageLogic {
    var repositories: [RepositoryStorageModel] {
        fetch()
    }
    private var container: ModelContainer?
    private let descriptor = FetchDescriptor<RepositoryStorageModel>()
    
    init() {
        container = try? ModelContainer(for: RepositoryStorageModel.self)
        container?.mainContext.autosaveEnabled = true
    }
    
    func deleteRepository(by index: Int) {
        let model = repositories[index]
        container?.mainContext.delete(model)
    }
    
    func editRepository(at index: Int, new: RepositoryModel) {
        let model = repositories[index]
        model.title = new.title
        model.subtitle = new.subtitle
    }
    
    func addRepositories(new: [RepositoryModel]) {
        new.forEach {
            let model = RepositoryStorageModel(title: $0.title, subtitle: $0.subtitle, imageUrl: $0.iconUrl)
            container?.mainContext.insert(model)
        }
    }
    
    private func fetch() -> [RepositoryStorageModel] {
        (try? container?.mainContext.fetch(descriptor)) ?? []
    }
}

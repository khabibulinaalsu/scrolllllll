//
//  GitHubViewController.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import UIKit
import SpriteKit

final class GitHubViewController: UITableViewController {
    var model: [RepositoryModel] = []
    
    private let interactor: GitHubInteractor
    
    init(interactor: GitHubInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCells()
        interactor.loadStart()
        print("view did load")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseId, for: indexPath) as? RepositoryCell {
            cell.setup(with: model[indexPath.row]) { [weak self] title, subtitle in
                if var new = self?.model[indexPath.row] {
                    new.title = title
                    new.subtitle = subtitle
                    self?.handleEdit(indexPath: indexPath, new: new)
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: .none) { [weak self] (action, view, completion) in self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage.trash
        deleteAction.backgroundColor = UIColor(red: 0.8, green: 0.5, blue: 0.5, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > model.count - 50 {
            needMoreRepositories()
        }
    }
    
    private func setupCells() {
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseId)
        tableView.allowsSelection = false
    }
    
    private func needMoreRepositories() {
        interactor.loadMoreRepositories()
    }
    
    private func handleDelete(indexPath: IndexPath) {
        interactor.deleteRepository(by: indexPath.row)
    }
    
    private func handleEdit(indexPath: IndexPath, new repo: RepositoryModel) {
        interactor.editRepository(by: indexPath.row, new: repo)
    }
}

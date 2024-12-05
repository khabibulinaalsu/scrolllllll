//
//  GitHubViewController.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import UIKit

// TODO: - delete
let image: UIImage? = UIImage(systemName: "gear")
let image2: UIImage? = UIImage(systemName: "box.truck")

let models: [RepositoryModel] = [
    .init(title: "aaaa", subtitle: "final class CardTableViewController: UITableViewController {var cards: [CardModel] = []override func viewDidLoad() {super.viewDidLoad() view.backgroundColor = .white } private func setupCells() { tableView.register(CardCell.self, forCellReuseIdentifier: CardCell.reuseId) } override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cards.count } override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { if let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.reuseId, for: indexPath) as? CardCell { cell.setup(with: .init(cards[indexPath.row])) return cell } return UITableViewCell() }", iconUrl: URL(string: "https://avatars.githubusercontent.com/u/1540564?v=4")),
    .init(title: "Aaa testing CardTableViewController: UITableViewController {var cards: [CardModel] = []override func viewDidLoad() {super.viewDidLoad() view.backgroundColor = .white }", subtitle: "final class}", iconUrl: URL(string: "https://avatars.githubusercontent.com/u/1540534?v=4")),
    .init(title: "Aaa test", subtitle: "", iconUrl: URL(string: "https://avatars.githubusercontent.com/u/1240564?v=4")),
    .init(title: "Aaa testing CardTableViewController: UITableViewController {var cards: [CardModel] = []override func viewDidLoad() {super.viewDidLoad() view.backgroundColor = .white }", subtitle: "", iconUrl: URL(string: "https://avatars.githubusercontent.com/u/1540565?v=4")),
    .init(title: "", subtitle: "Aaa testing CardTableViewController: UITableViewController {var cards: [CardModel] = []override func viewDidLoad() {super.viewDidLoad() view.backgroundColor = .white }", iconUrl: URL(string: "https://avatars.githubusercontent.com/u/6258906?v=4")),
]

final class GitHubViewController: UITableViewController {
    var model: [RepositoryModel] = []// []) // models) // [])
    
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
    
    private func setupCells() {
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseId)
        tableView.allowsSelection = false
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
    
    private func handleDelete(indexPath: IndexPath) {
        interactor.deleteRepository(by: indexPath.row)
    }
    
    private func handleEdit(indexPath: IndexPath, new repo: RepositoryModel) {
        interactor.editRepository(by: indexPath.row, new: repo)
    }
}

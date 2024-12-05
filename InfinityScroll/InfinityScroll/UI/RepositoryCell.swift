//
//  RepositoryCell.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import UIKit

final class RepositoryCell: UITableViewCell {
    static public let reuseId = "RepositoryCell"
    
    private let container = UIView()
    private let icon = UIImageView()
    private let title = UITextView()
    private let subtitle = UITextView()
    private var editAction: ((String, String) -> Void)?
    
    private var imageDownloadTask: Task<Void, Never>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        icon.image = nil
        loadCell()
    }
    
    public func setup(with model: RepositoryModel, editAction: @escaping (String, String) -> Void) {
        self.editAction = editAction
        title.text = model.title
        subtitle.text = model.subtitle
        imageDownloadTask = Task {
            icon.image = await loadImage(from: model.iconUrl) ?? .withoutImage
        }
    }
    
    private func loadImage(from url: URL?) async -> UIImage? {
        guard let url else { return nil }
        let data = try? await URLSession.shared.data(from: url).0
        return data.flatMap(UIImage.init(data:))
    }
    
    private func loadCell() {
        container.removeFromSuperview()
        title.delegate = self
        subtitle.delegate = self
        setupLayout()
        setupStyle()
    }

    private func setupLayout() {
        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 0
        textStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [icon, textStack])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        
        contentView.addSubview(container)
        container.addSubview(stack)
        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 100),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupStyle() {
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 16
        icon.backgroundColor = .systemGray6
        
        title.font = .systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.isScrollEnabled = false
        
        subtitle.font = .systemFont(ofSize: 16)
        subtitle.textColor = .systemGray2
        subtitle.textAlignment = .left
        subtitle.isScrollEnabled = false
    }
}

extension RepositoryCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        editAction?(title.text, subtitle.text)
    }
}

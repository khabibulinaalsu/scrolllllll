//
//  RepositoryStorageModel.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import SwiftData
import Foundation

@Model
final class RepositoryStorageModel {
    var title: String
    var subtitle: String
    var imageUrl: URL?
    
    init(title: String, subtitle: String, imageUrl: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}

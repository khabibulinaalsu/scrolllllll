//
//  UIImage+Extensions.swift
//  InfinityScroll
//
//  Created by Alsu Khabibulina  on 05.12.2024.
//

import UIKit

extension UIImage {
    static var withoutImage: UIImage? {
        UIImage(systemName: "person.crop.square")
    }
    static var trash: UIImage? {
        UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
    }
}

//
//  Collage.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 29/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation
import UIKit

class Collage {
    private var photos: [UIImage?] = Array(repeating: nil, count: 4)
    private var layout: CollageLayout = .layout1
    var result: UIImage = UIImage()

    // Make the model a singleton as we won't need several instances of it
    static let shared: Collage = Collage()
    // Private init for a singleton
    private init() {}

    func replacePicture(atIndex index: Int, withImage image: UIImage) {
        photos[index] = image

        let notification: Notification = Notification(
            name: .pictureChanged,
            userInfo: [Notification.Key.images: photos]
        )
        NotificationCenter.default.post(notification)
    }

    func changeLayout(for layout: CollageLayout) {
        self.layout = layout

        let notification: Notification = Notification(
            name: .layoutChanged,
            userInfo: [Notification.Key.layout: self.layout]
        )
        NotificationCenter.default.post(notification)
    }
}

enum CollageLayout: Int {
    case layout1, layout2, layout3

    // Should the layout hide a given picture?
    // [Top Big Picture, Bottom Big Picture, Top Left, Top Right, Bottom Left, Bottom Right]
    // Example for layout1: (first row is a single big picture, second row is two small pictures)
    // We should not hide the Top Big Picture nor the Bottom small ones, but all the others)
    var hiddenElements: [Bool] {
        switch self {
        case .layout1: return [false, true, true, true, false, false]
        case .layout2: return [true, false, false, false, true, true]
        case .layout3: return [true, true, false, false, false, false]
        }
    }
}

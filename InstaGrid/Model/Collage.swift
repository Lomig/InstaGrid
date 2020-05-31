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

    // Notification userInfo keys
    static let photosKey = "PICTURES"
    static let layoutKey = "LAYOUT"

    func changePicture(atPosition index: Int) {

        let notification: Notification = Notification(
            name: Notification.Name(rawValue: "PicturesChanged"),
            userInfo: [Collage.photosKey: photos]
        )
        NotificationCenter.default.post(notification)
    }

    func changeLayout(for layout: CollageLayout) {
        self.layout = layout

        let notification: Notification = Notification(
            name: Notification.Name(rawValue: "LayoutChanged"),
            userInfo: [Collage.layoutKey: self.layout]
        )
        NotificationCenter.default.post(notification)
    }

    func create() {

    }

    func share() {

    }
}

enum CollageLayout: Int {
    case layout1, layout2, layout3

    // Should the layout hide a given picture?
    // Top Big Picture, Bottom Big Picture, Top Left, Top Right, Bottom Left, Bottom Right
    var hiddenElements: [Bool] {
        switch self {
        case .layout1: return [false, true, true, true, false, false]
        case .layout2: return [true, false, false, false, true, true]
        case .layout3: return [true, true, false, false, false, false]
        }
    }
}

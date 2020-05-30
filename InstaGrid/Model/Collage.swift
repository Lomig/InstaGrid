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

    func changePicture(atPosition index: Int) {

    }

    func changeLayout(for layout: CollageLayout) {
        self.layout = layout
    }

    func create() {

    }

    func share() {

    }
}

enum CollageLayout {
    case layout1, layout2, layout3
}

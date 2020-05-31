//
//  LayoutSelector.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 31/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation
import UIKit

class LayoutSelector: UIControl {
    @IBOutlet var background: UIImageView!
    @IBOutlet var checkMark: UIImageView!

    func check() {
        checkMark.isHidden = false
    }

    func uncheck() {
        checkMark.isHidden = true
    }
}

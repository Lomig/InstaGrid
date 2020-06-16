//
//  LayoutSelector.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 31/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation
import UIKit

class LayoutSelector: UIButton {
    @IBOutlet var background: UIImageView!
    @IBOutlet var checkMark: UIImageView!

    func check() {
        checkMark.isHidden = false
        self.isEnabled = false
    }

    func uncheck() {
        checkMark.isHidden = true
        self.isEnabled = true
    }

    // Make the button transparent on touch
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != self.isHighlighted else { return }

            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction],
                animations: { self.alpha = self.isHighlighted ? 0.5 : 1 },
                completion: nil)
        }
    }
}

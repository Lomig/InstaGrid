//
//  PicturePlaceholderView.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 29/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation
import UIKit

class PicturePlaceholder: UIControl {
    @IBOutlet var plusButton: UIView!
    @IBOutlet var image: UIImageView!

    func replacePicture(with boxedPicture: UIImage?) {
        guard let picture = boxedPicture else { return hidePicture() }

        plusButton.isHidden = true
        image.isHidden = false
        image.image = picture
        image.contentMode = .scaleAspectFill
    }

    private func hidePicture() {
        image.isHidden = true
        plusButton.isHidden = false
    }
}

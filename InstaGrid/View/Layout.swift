//
//  LayoutView.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 29/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation
import UIKit

class Layout: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.InstaGrid.darkBlue
    }

    @IBOutlet var largePicture1: PicturePlaceholder!
    @IBOutlet var largePicture2: PicturePlaceholder!
    @IBOutlet var smallPicture1: PicturePlaceholder!
    @IBOutlet var smallPicture2: PicturePlaceholder!
    @IBOutlet var smallPicture3: PicturePlaceholder!
    @IBOutlet var smallPicture4: PicturePlaceholder!

    func setLayout(_ layout: CollageLayout) {
        self.subviews.enumerated().forEach { (index, placeHolder) in
            placeHolder.isHidden = layout.hiddenElements[index]
        }
    }
}

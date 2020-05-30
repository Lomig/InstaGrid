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

    @IBOutlet var largePicture1: UIView!
    @IBOutlet var largePicture2: UIView!
    @IBOutlet var smallPicture1: UIView!
    @IBOutlet var smallPicture2: UIView!
    @IBOutlet var smallPicture3: UIView!
    @IBOutlet var smallPicture4: UIView!
}

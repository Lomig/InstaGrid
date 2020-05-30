//
//  Layout1View.swift
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

    @IBOutlet var largePicture_1: UIView!
    @IBOutlet var largePicture_2: UIView!
    @IBOutlet var smallPicture_1: UIView!
    @IBOutlet var smallPicture_2: UIView!
    @IBOutlet var smallPicture_3: UIView!
    @IBOutlet var smallPicture_4: UIView!
}

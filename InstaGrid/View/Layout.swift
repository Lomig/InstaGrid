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

    func toImage() -> UIImage {
        // UIGraphicsBeginImageContext is deprecated starting iOS 10
        // Using UIGraphicsImageRenderer instead
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

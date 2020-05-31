//
//  ViewController.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 29/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Model
    var collage: Collage = Collage()

    // View
    @IBOutlet var layout: Layout!
    @IBOutlet var layoutSelectors: UIView!

    @IBAction func didTapLayoutSelector1() { selectLayout(.layout1) }
    @IBAction func didTapLayoutSelector2() { selectLayout(.layout2) }
    @IBAction func didTapLayoutSelector3() { selectLayout(.layout3) }

    // On Load
    override func viewDidLoad() {
        super.viewDidLoad()

        connectNotifications()
    }

    @objc func layoutChanged(_ notification: Notification) {
        let newLayout: CollageLayout = notification.userInfo![Collage.layoutKey] as! CollageLayout

        layout.setLayout(newLayout)

        clearLayoutSelectors()
        checkLayoutSelector(forLayout: newLayout)
    }

    @objc func picturesChanged(_ notification: Notification) {
        
    }

    private func connectNotifications() {
        var notificationName: NSNotification.Name = Notification.Name(rawValue: "LayoutChanged")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(layoutChanged(_:)),
            name: notificationName,
            object: nil
        )

        notificationName = Notification.Name(rawValue: "PicturesChanged")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(picturesChanged(_:)),
            name: notificationName,
            object: nil
        )
    }

    private func clearLayoutSelectors() {
        layoutSelectors.subviews.forEach { subview in
            guard let layoutSelector = subview as? LayoutSelector else { return }

            layoutSelector.uncheck()
        }
    }

    private func checkLayoutSelector(forLayout layout: CollageLayout) {
        let selectors = layoutSelectors.subviews.compactMap { subview in subview as? LayoutSelector }
        selectors[layout.rawValue].check()
    }

    private func selectLayout(_ layout: CollageLayout) {
        collage.changeLayout(for: layout)
    }
}


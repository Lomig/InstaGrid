//
//  ViewController.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 29/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    private var currentImageIndex: Int = 0


    // Model
    private var collage: Collage = Collage()

    // View
    @IBOutlet private var layout: Layout!
    @IBOutlet private var layoutSelectors: UIView!

    // Actions
    @IBAction private func didTapLayoutSelector1() { selectLayout(.layout1) }
    @IBAction private func didTapLayoutSelector2() { selectLayout(.layout2) }
    @IBAction private func didTapLayoutSelector3() { selectLayout(.layout3) }

    @IBAction private func didTapPicture1() { startChangePicture(atIndex: 0) }
    @IBAction private func didTapPicture2() { startChangePicture(atIndex: 1) }
    @IBAction private func didTapPicture3() { startChangePicture(atIndex: 2) }
    @IBAction private func didTapPicture4() { startChangePicture(atIndex: 3) }

    // On Load
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        connectNotifications()
    }

    @objc func onLayoutChanged(_ notification: Notification) {
        let newLayout: CollageLayout = notification.userInfo![Collage.layoutKey] as! CollageLayout

        layout.setLayout(newLayout)

        clearLayoutSelectors()
        checkLayoutSelector(forLayout: newLayout)
    }

    @objc func onPicturesChanged(_ notification: Notification) {
        let images: [UIImage?] = notification.userInfo![Collage.photosKey] as! [UIImage?]

        layout.largePicture1.replacePicture(with: images[0])
        layout.largePicture2.replacePicture(with: images[2])
        layout.smallPicture1.replacePicture(with: images[0])
        layout.smallPicture2.replacePicture(with: images[1])
        layout.smallPicture3.replacePicture(with: images[2])
        layout.smallPicture4.replacePicture(with: images[3])
    }

    private func connectNotifications() {
        var notificationName: NSNotification.Name = Notification.Name(rawValue: "LayoutChanged")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLayoutChanged(_:)),
            name: notificationName,
            object: nil
        )

        notificationName = Notification.Name(rawValue: "PicturesChanged")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPicturesChanged(_:)),
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

    private func startChangePicture(atIndex index: Int) {
        present(imagePicker, animated: true, completion: { self.currentImageIndex = index })
    }

    private func completeChangePicture(with image: UIImage) {
        collage.replacePicture(atIndex: currentImageIndex, withImage: image)
    }
}

// Handling Image Picker through extension
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            completeChangePicture(with: pickedImage)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


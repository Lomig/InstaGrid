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

    private var layoutAnimationVector: CGPoint = CGPoint(x: 0, y: -1)

    // Model
    private var collage: Collage = Collage()

    // View
    @IBOutlet private var layout: Layout!
    @IBOutlet private var layoutSelectors: UIView!
    @IBOutlet private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet private var swipeMessage: UILabel!
    @IBOutlet private var swipeArrow: UIImageView!

    // Actions
    @IBAction private func didTapLayoutSelector1() { selectLayout(.layout1) }
    @IBAction private func didTapLayoutSelector2() { selectLayout(.layout2) }
    @IBAction private func didTapLayoutSelector3() { selectLayout(.layout3) }

    @IBAction private func didTapPicture1() { startChangePicture(atIndex: 0) }
    @IBAction private func didTapPicture2() { startChangePicture(atIndex: 1) }
    @IBAction private func didTapPicture3() { startChangePicture(atIndex: 2) }
    @IBAction private func didTapPicture4() { startChangePicture(atIndex: 3) }

    @IBAction private func didSwipe(_ gesture: UISwipeGestureRecognizer) { animateLayout() }

    // On View Load - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.InstaGrid.lightBlue
        layout.backgroundColor = UIColor.InstaGrid.darkBlue

        initializeImagePicker()
        connectNotifications()
    }


    //----------------------------------------------------------------------
    // Initialization Helpers
    //----------------------------------------------------------------------

    private func initializeImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }

    private func connectNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLayoutChanged(_:)),
            name: .layoutChanged,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPicturesChanged(_:)),
            name: .pictureChanged,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDeviceRotated),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }


    //----------------------------------------------------------------------
    // On Notifications
    //----------------------------------------------------------------------

    @objc func onDeviceRotated() {
        if UIDevice.current.orientation.isLandscape {
            swipeGestureRecognizer.direction = .left
            layoutAnimationVector = CGPoint(x: -1, y: 0)
            swipeArrow.image = #imageLiteral(resourceName: "Arrow Left")
            swipeMessage.text = "Swipe left to share"
        } else {
            swipeGestureRecognizer.direction = .up
            layoutAnimationVector = CGPoint(x: 0, y: -1)
            swipeArrow.image = #imageLiteral(resourceName: "Arrow Up")
            swipeMessage.text = "Swipe up to share"
        }
    }

    @objc func onLayoutChanged(_ notification: Notification) {
        let newLayout: CollageLayout = notification.userInfo![Notification.Key.layout] as! CollageLayout

        layout.setLayout(newLayout)

        clearLayoutSelectors()
        checkLayoutSelector(forLayout: newLayout)
    }

    @objc func onPicturesChanged(_ notification: Notification) {
        let images: [UIImage?] = notification.userInfo![Notification.Key.images] as! [UIImage?]

        layout.largePicture1.replacePicture(with: images[0])
        layout.largePicture2.replacePicture(with: images[2])
        layout.smallPicture1.replacePicture(with: images[0])
        layout.smallPicture2.replacePicture(with: images[1])
        layout.smallPicture3.replacePicture(with: images[2])
        layout.smallPicture4.replacePicture(with: images[3])
    }


    //----------------------------------------------------------------------
    // Layout Selection
    //----------------------------------------------------------------------

    // Remove all check mark on Layout Selectors
    private func clearLayoutSelectors() {
        layoutSelectors.subviews.forEach { subview in
            guard let layoutSelector = subview as? LayoutSelector else { return }

            layoutSelector.uncheck()
        }
    }

    // Add a check mark on a selected Layout
    private func checkLayoutSelector(forLayout layout: CollageLayout) {
        let selectors = layoutSelectors.subviews.compactMap { subview in subview as? LayoutSelector }
        selectors[layout.rawValue].check()
    }

    // Tap Action: Select a Layout
    private func selectLayout(_ layout: CollageLayout) {
        collage.changeLayout(for: layout)
    }

    //----------------------------------------------------------------------
    // Image Selection
    //----------------------------------------------------------------------

    // Tap Action: Open the Image Picker
    // We save the index where we want to save the Image once it's selected
    private func startChangePicture(atIndex index: Int) {
        present(imagePicker, animated: true, completion: { self.currentImageIndex = index })
    }

    // Add the selected Image returned from the Image Picker
    private func completeChangePicture(with image: UIImage) {
        collage.replacePicture(atIndex: currentImageIndex, withImage: image)
    }


    //----------------------------------------------------------------------
    // Sharing Collage
    //----------------------------------------------------------------------

    // Animate the Collage as per requirement
    // A Swipe move the collage away
    // The same function is used "reversed" to make the collage come back
    private func animateLayout(backwards: Bool = false) {
        let vector: CGPoint = backwards ? CGPoint(x: -1 * layoutAnimationVector.x, y: -1 * layoutAnimationVector.y) : layoutAnimationVector
        let screenSize: CGRect = UIScreen.main.bounds
        let translation: CGAffineTransform = CGAffineTransform(translationX: vector.x * screenSize.width, y: vector.y * screenSize.height)

        UIView.animate(
            withDuration: 0.4,
            animations: { self.layout.transform = translation },
            completion: { success in
                if success && !backwards { self.shareCollage() }
            }
        )
    }

    // Create the image of the collage, and share it
    private func shareCollage() {
        collage.result = layout.toImage()

        let sharedView = UIActivityViewController(activityItems: [collage.result], applicationActivities: nil)
        sharedView.completionWithItemsHandler = { (_: UIActivity.ActivityType?, _: Bool, _: [Any]?, _: Error?) in
            self.animateLayout(backwards: true)
            self.layout.transform = .identity
        }
        present(sharedView, animated: true)
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


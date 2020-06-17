//
//  ViewController.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 29/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import UIKit
import LinkPresentation

class ViewController: UIViewController {
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    private var currentImageIndex: Int = 0
    private var result: UIImage = UIImage()

    private var layoutAnimationVector: CGPoint = CGPoint(x: 0, y: 1)

    // Model
    private var collage: Collage = Collage.shared

    // View
    @IBOutlet private var mainView: UIView!
    @IBOutlet private var layout: Layout!
    @IBOutlet private var layoutSelectors: UIStackView!
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

    // On View Load - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.InstaGrid.lightBlue
        layout.backgroundColor = UIColor.InstaGrid.darkBlue

        checkLayoutSelector(forLayout: .layout1)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(animateLayout(_:)))
        self.mainView.addGestureRecognizer(panRecognizer)

        initializeImagePicker()
        connectNotifications()
    }


    //----------------------------------------------------------------------
    // MARK: - Initialization Helpers
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onCollageShare),
            name: .shareCollage,
            object: nil
        )
    }


    //----------------------------------------------------------------------
    // MARK: - On Notifications
    //----------------------------------------------------------------------

    @objc func onDeviceRotated() {
        if UIDevice.current.orientation.isLandscape {
            layoutAnimationVector = CGPoint(x: 1, y: 0)
            swipeArrow.image = #imageLiteral(resourceName: "Arrow Left")
            swipeMessage.text = "Swipe left to share"
        } else {
            layoutAnimationVector = CGPoint(x: 0, y: 1)
            swipeArrow.image = #imageLiteral(resourceName: "Arrow Up")
            swipeMessage.text = "Swipe up to share"
        }
    }

    @objc func onLayoutChanged(_ notification: Notification) {
        let newLayout: CollageLayout = notification.userInfo![Notification.Key.layout] as! CollageLayout

        changeLayoutWithAnimation(forLayout: newLayout)

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

    @objc func onCollageShare(_ notification: Notification) {
        let canShare: Bool = notification.userInfo![Notification.Key.shareStatus] as! Bool

        if canShare {
            shareCollage()
            finishDragAnimation()

        } else {
            resetDragAnimation()
            let alert: UIAlertController = UIAlertController(title: "Error 😕",
                                                             message: "Your Instagrid is not complete!",
                                                             preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default))

            present(alert, animated: true, completion: nil)
        }
    }


    //----------------------------------------------------------------------
    // MARK: - Layout Selection
    //----------------------------------------------------------------------

    // Remove all check mark on Layout Selectors
    private func clearLayoutSelectors() {
        layoutSelectors.subviews.forEach { subview in
            guard let layoutSelector = subview as? LayoutSelector else { return }

            layoutSelector.showsTouchWhenHighlighted = true
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

    // Animation: Remove previous layout
    private func changeLayoutWithAnimation(forLayout newLayout: CollageLayout) {
        let scaling = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(
            withDuration: 0.3,
            animations: { self.layout.transform = scaling },
            completion: { success in
                if success { self.showNewLayoutWithAnimation(forLayout: newLayout) }
            }
        )
    }

    // Animation: Show new layout
    private func showNewLayoutWithAnimation(forLayout newLayout: CollageLayout) {
        self.layout.setLayout(newLayout)

        UIView.animate(
            withDuration: 0.3,
            animations: { self.layout.transform = .identity }
        )
    }

    //----------------------------------------------------------------------
    // MARK: - Image Selection
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
    // MARK: - Sharing Collage
    //----------------------------------------------------------------------

    // Animate the Collage as per requirement
    // A Swipe move the collage away
    @objc private func animateLayout(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            onDragViewWith(gesture: sender)
        case .cancelled, .ended:
            onDragFinishWith(gesture: sender)
        default:
            return
        }

    }

    // Handle Drag Animation
    private func onDragViewWith(gesture: UIPanGestureRecognizer) {
        let translation: CGPoint = gesture.translation(in: layout)

        // Drag can only work upwards (portrait) or leftwards (landscape)
        let translationX: CGFloat = translation.x > 0 ? 0 : translation.x * layoutAnimationVector.x
        let translationY: CGFloat = translation.y > 0 ? 0 : translation.y * layoutAnimationVector.y
        let transform: CGAffineTransform = CGAffineTransform(translationX: translationX,
                                                                        y: translationY)

        layout.transform = transform
        swipeMessage.transform = transform
        swipeArrow.transform = transform
    }

    // When finish dragging the view, check if we cant to share the Collage or not
    // It depends it we dragged it enough
    private func onDragFinishWith(gesture: UIPanGestureRecognizer) {
        // How much drag do we need to consider sharing, in percent?
        let threshold: CGFloat = 0.25

        // How much did we drag the view on the screen, in percent?
        let translationInViewX: CGFloat = abs(gesture.translation(in: mainView).x * layoutAnimationVector.x / mainView.bounds.width)
        let translationInViewY: CGFloat = abs(gesture.translation(in: mainView).y * layoutAnimationVector.y / mainView.bounds.height)

        if translationInViewX > threshold || translationInViewY > threshold {
            collage.share()
        } else {
            resetDragAnimation()
        }
    }

    // Finish the animation if we are to create the Collage
    private func finishDragAnimation() {
        let translation: CGAffineTransform = CGAffineTransform(translationX: -layoutAnimationVector.x * mainView.frame.width,
                                                                          y: -layoutAnimationVector.y * mainView.frame.height)

        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.layout.transform = translation
                self.swipeMessage.transform = translation
                self.swipeArrow.transform = translation
            }
        )
    }

    // Put back the views when sharing is cancelled or completed
    private func resetDragAnimation() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            animations: {
                self.layout.transform = .identity
                self.swipeMessage.transform = .identity
                self.swipeArrow.transform = .identity
            }
        )
    }

    // Create the image of the collage, and share it
    private func shareCollage() {
        result = layout.toImage()
        let shareView: UIActivityViewController = UIActivityViewController(activityItems: [result, self], applicationActivities: nil)

        shareView.popoverPresentationController?.sourceView = mainView
        shareView.completionWithItemsHandler = { (_, _, _, _) in
            self.resetDragAnimation()
        }

        // Needed to prevent a warning in iOS 13+
        if #available(iOS 13.0, *) {
            shareView.isModalInPresentation = true
        }

        present(shareView, animated: true, completion: nil)
    }
}



// Handling Image Picker through extension
// MARK: - Image Picker Handler
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


// MARK: - ActivityView Handler
// Handling ShareSheet through extension
extension ViewController: UIActivityItemSource {

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }

    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let image: UIImage = result
        let imageProvider: NSItemProvider = NSItemProvider(object: image)
        let metadata: LPLinkMetadata = LPLinkMetadata()

        metadata.imageProvider = imageProvider
        metadata.title = "My new Instagrid Picture!"

        return metadata
    }
}

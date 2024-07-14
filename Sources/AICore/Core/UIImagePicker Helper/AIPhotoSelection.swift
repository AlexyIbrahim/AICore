//
//  AIPhotoSelection.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/16/22.
//

import Foundation
import UIKit

public class AIPhotoSelection: NSObject {
    struct AlertButton {
        let title: String
        let callback: (() -> Void)?
        let style: UIAlertAction.Style

        init(title: String, callback: (() -> Void)? = nil, style: UIAlertAction.Style? = nil) {
            self.title = title
            self.callback = callback ?? nil
            self.style = style ?? .default
        }
    }

    static let shared = AIPhotoSelection()
    let imagePicker = UIImagePickerController()
    var image_callback: ((UIImage) -> Void)?

    public final class func selectImage(inViewController viewController: UIViewController, from source: UIImagePickerController.SourceType, image_callback: ((UIImage) -> Void)? = nil) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            shared.imagePicker.delegate = shared
            shared.imagePicker.sourceType = source
            shared.imagePicker.allowsEditing = false
            shared.image_callback = image_callback

            viewController.present(shared.imagePicker, animated: true, completion: nil)
        }
    }
}

extension AIPhotoSelection: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: { () in
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.image_callback?(pickedImage)
            }
        })
    }

    public func imagePickerControllerDidCancel(_: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

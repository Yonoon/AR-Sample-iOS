//
//  InstaManager.swift
//  SamsungAR
//
//  Created by yonghoon park on 10/10/2019.
//  Copyright © 2019 samsung. All rights reserved.
//

//https://medium.com/we-talk-it/instagram-api-authentication-using-swift-3bf27d7ed6aa

import UIKit
import Foundation

class InstagramHelper: NSObject, UIDocumentInteractionControllerDelegate {
    private let ACCESS_TOKEN: String = "14001469409.58b58af.08d0f02a40a14747bb498447ef1249f3"
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"

    var documentInteractionController = UIDocumentInteractionController()

    class var sharedManager: InstagramHelper {
        struct Singleton {
            static let instance = InstagramHelper()
        }
        return Singleton.instance
    }

    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, controller: UIViewController) {
        let instagramURL = URL(string: kInstagramURL)

        DispatchQueue.main.async {

            if UIApplication.shared.canOpenURL(instagramURL!) {

                let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(self.kfileNameExtension)
                if let jpegData = imageInstagram.jpegData(compressionQuality: 1.0){
                    do {
                        try jpegData.write(to: URL(fileURLWithPath: jpgPath), options: .atomicWrite)

                    } catch {
                        print("write image failed")
                    }
                }
                let fileURL = NSURL.fileURL(withPath: jpgPath)
                self.documentInteractionController.url = fileURL
                self.documentInteractionController.delegate = self
                self.documentInteractionController.uti = self.kUTI

                // adding caption for the image
                self.documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
                self.documentInteractionController.presentOpenInMenu(from: controller.view.frame, in: controller.view, animated: true)
            } else {

                // alert displayed when the instagram application is not available in the device
                self.showAlert("", message: self.kAlertViewMessage, controller: controller)
            }
        }
    }


    func showAlert(_ title: String, message: String, controller : UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            let selector: Selector = NSSelectorFromString("alertOkButtonHandler")
            if controller.responds(to: selector){
                _ = controller.perform(selector)
            }
        })
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
}

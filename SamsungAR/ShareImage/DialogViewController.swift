//
//  DialogViewController.swift
//  SamsungAR
//
//  Created by yonghoon park on 27/09/2019.
//  Copyright © 2019 samsung. All rights reserved.
//

import UIKit
import MessageUI

public class DialogViewController: UIViewController {

    @IBOutlet var dialogView: UIView!
    @IBOutlet var imgView: UIImageView!

    var image: UIImage!
    var selectedItem: [Appliance]!

    public override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = image
        setCornorRadius()

        // Do any additional setup after loading the view.
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    func setCornorRadius() {
        dialogView.layer.cornerRadius = 30
        dialogView.layer.masksToBounds = true
    }

    func setBtnBorderColor() {
        
    }


    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func selfDestruct() {
        //Do Dismiss
        print("do dismiss")
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func saveImageInGallery(_ sender: Any) {
       // action(firstButtonText)
        guard let captureImg = self.imgView.image else { return }
        saveImage(image: captureImg)
        selfDestruct()
    }

    @IBAction func shareToInstagram(_ sender: Any) {
       //action(secondButtonText)
        selfDestruct()
        guard let captureImg = self.imgView.image else { return }
        InstagramHelper.sharedManager.postImageToInstagramWithCaption(imageInstagram: captureImg, instagramCaption: "", controller: self.presentingViewController ?? self)

    }

    @IBAction func eMail_Estimate(_ sender: Any) {
       // action(secondButtonText)
        sendMail()
       // selfDestruct()
    }

    @IBAction func cancel(_ sender: Any) {
        // action(secondButtonText)

        selfDestruct()
    }

    func saveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.finishWriteImage), nil)
    }

    @objc private func finishWriteImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            // Something wrong happened.
            print("SAVE IMAGE ERROR OCCUR!!!!!!!!!: \(String(describing: error))!!!!!!!!!!")
        } else {
            // Everything is alright.
            print("Capture Image Saved success!")
        }
    }


}

extension DialogViewController: MFMailComposeViewControllerDelegate {
    func sendMail() {

        if MFMailComposeViewController.canSendMail() {
            self.present(configuredMailComposeViewController(), animated: true, completion: nil)
        } else {
            print("Can't Send Mail Now")
        }
    }


    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
         composeVC.setCcRecipients(["digital@plaza.com"]) //수신
        composeVC.setSubject("[견적 요청] ") //제목
        composeVC.setMessageBody("견적 내주세여!! \n \(getSelectedItemsString())", isHTML: false) //본문
        let imageData: Data = image.pngData()!
        composeVC.addAttachmentData(imageData, mimeType: "image/png", fileName: "capture.png")
        return composeVC
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func getSelectedItemsString() -> String {
        var str = String()
        for item in selectedItem {
            str.append("[\(item.category)] : \(item.type) - \(item.model) \n")
        }
        return str
    }
}

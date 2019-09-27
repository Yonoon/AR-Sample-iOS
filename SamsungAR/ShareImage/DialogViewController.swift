//
//  DialogViewController.swift
//  SamsungAR
//
//  Created by yonghoon park on 27/09/2019.
//  Copyright © 2019 samsung. All rights reserved.
//

import UIKit

public class DialogViewController: UIViewController {

    @IBOutlet var dialogView: UIView!
    @IBOutlet var imgView: UIImageView!

    var image: UIImage!

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
    }

    @IBAction func eMail_Estimate(_ sender: Any) {
       // action(secondButtonText)

        selfDestruct()
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

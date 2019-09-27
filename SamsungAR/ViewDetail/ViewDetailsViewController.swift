//
//  ViewDetailsViewController.swift
//  SamsungAR
//
//  Created by yonghoon park on 24/09/2019.
//  Copyright © 2019 samsung. All rights reserved.
//

import UIKit
import SceneKit

class ViewDetailsViewController: UIViewController {

    @IBOutlet var descLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    var selectedItem: Appliance?


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedItem = self.selectedItem else { return }
        // 1: Load .obj file
        setLabel()

        let scene = SCNScene(named: "art.scnassets/\(selectedItem.category)/\(selectedItem.type)/\(selectedItem.model).dae")
        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
        // 4: Set camera on scene
        scene?.rootNode.addChildNode(cameraNode)

        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(lightNode)

        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)

        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true

        // Show FPS logs and timming
        // sceneView.showsStatistics = true

        // Set background color
        sceneView.backgroundColor = UIColor.white

        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false

        // Set scene settings
        sceneView.scene = scene
      //  addExitButton()
    }

    func setLabel() {
        self.descLabel.text = selectedItem?.description
        self.modelLabel.text = selectedItem?.model
        self.typeLabel.text = selectedItem?.type
    }

//    func addExitButton() {
//        let button = UIButton()
//        print("width \(self.view.frame.size.width), height: \(self.view.frame.size.height)")
//        button.frame = CGRect(x: self.view.frame.size.width - 45, y: 15, width: 30, height: 30)
//        button.setImage(UIImage(named: "Icon-X-Gray.png"), for: .normal)
//        button.backgroundColor = UIColor.clear
//
//        button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
//        self.view.addSubview(button)
//    }
//
//    @objc func popVC() {
//
//    }

    @IBAction func popVC(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
}

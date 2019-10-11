//
//  ViewController.swift
//  ARFoodFinal
//
//  Created by Koushan Korouei on 13/10/2018.
//  Copyright © 2018 Koushan Korouei. All rights reserved.
//

//WWDC: https://www.youtube.com/watch?v=S14AVwaBF-Y
//ARKit의 기본 프로세스는 iOS 장치 카메라에서 비디오 프레임을 읽는 것입니다. 각 프레임마다 이미지가 처리되고 특징점이 추출됩니다.
//A9 / A10 프로세서로 제한되므로 앱을 실행하려면 iPad 또는 iPad 2017 모델에서 iPhone SE, iPhone6S, iPhone 6S Plus 이상

import UIKit
import SceneKit
import ARKit

protocol SelectObjDelegate {
    func setSelectedObj(_ item: Appliance)
}

class ViewController: UIViewController, ARSCNViewDelegate {
    var lastPanPosition: SCNVector3?
    var panningNode: SCNNode?
    var panStartZ: CGFloat?
    
    var currentAngleY: Float = 0.0 // for rotate
    
    var selectedNodelist =  [Appliance]()
    var currentSelectedItem: Appliance!
    
    @IBOutlet weak var label: UILabel!
    //카메라를 제어하고 장치에서 모든 센서 데이터를 수집하여 원활한 환경을 구축합니다
    @IBOutlet var sceneView: ARSCNView!
    var planes = [OverlayPlane]()

    var selectedNode = SCNNode()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = ARSCNView(frame : self.view.frame)
        self.view.addSubview(sceneView)
        addPlusButton()
        addCameraButton()
        addSwitch()
      //  self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Register delegate
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        
        //        //box 만들어줌 좌표는 대략 미터와 일치 0.1 -> 10센치
        //        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        //        //box의 node를 만들어줌
        //        let boxNode = SCNNode(geometry: box)
        //        //boxNode의 각도 설정
        //        //네번쨰꺼는 나와의 거리인듯
        //        boxNode.rotation = SCNVector4Make(0, 0, 0, -Float.pi / 2)
        //
        //
        //        //  scene.rootNode.addChildNode(boxNode)
        //        //sceneView.autoenablesDefaultLighting = true;
        sceneView.scene = scene

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //수평의 면만 인식하자!
        configuration.planeDetection = .horizontal
        //configuration.environmentTexturing = .automatic
        
        
        //Run the view's session
        sceneView.session.run(configuration)
        
        registerGestureRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func addPlusButton() {
        let button = UIButton()
        print("width \(self.view.frame.size.width), height: \(self.view.frame.size.height)")
        button.frame = CGRect(x: self.view.frame.size.width/2 - 24, y: self.view.frame.size.height - 100, width: 48, height: 48)
        button.setImage(UIImage(named: "add@2x.png"), for: .normal)
        button.backgroundColor = UIColor.clear
        
        button.addTarget(self, action: #selector(showPlusMenu), for: .touchUpInside)
        self.view.addSubview(button)
    }

    func addCameraButton() {
        let button = UIButton()
        print("width \(self.view.frame.size.width), height: \(self.view.frame.size.height)")
        button.frame = CGRect(x: self.view.frame.size.width - 65, y: self.view.frame.size.height - 100, width: 55, height: 55)
        button.setImage(UIImage(named: "camera.png"), for: .normal)
        button.backgroundColor = UIColor.clear

        button.addTarget(self, action: #selector(captureARScene), for: .touchUpInside)
        self.view.addSubview(button)
    }

    func addSwitch() {
        let toggleSwitch = UISwitch()
        toggleSwitch.frame = CGRect(x: 20, y: self.view.frame.size.height - 90, width: 50, height: 20)
        toggleSwitch.setOn(true, animated: true)

        let text = UILabel()
        text.text = "Debug"
        text.textColor = UIColor.white
        text.font = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.medium)
        text.frame = CGRect(x: 30, y: self.view.frame.size.height - 110, width: 80, height: 20)

        toggleSwitch.addTarget(self, action: #selector(onClickSwitch), for: .valueChanged)

        self.view.addSubview(toggleSwitch)
        self.view.addSubview(text)
    }

    @objc func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            planes.forEach { (plane) in
                 plane.isHidden = false

            }
        } else {
            planes.forEach { (plane) in
                 plane.isHidden = true
            }
        }
    }

    @objc func captureARScene() {
        let image = sceneView.snapshot()
        print("debug Snapshoe")

        let storyboard = UIStoryboard(name: "DialogView", bundle: nil)
        let DialogViewController = storyboard.instantiateViewController(withIdentifier: "DialogViewController") as? DialogViewController
        DialogViewController?.modalPresentationStyle = .overCurrentContext
        if let DialogViewController = DialogViewController {
            DialogViewController.image = image
            self.present(DialogViewController, animated: true, completion: nil)
        }
        //DO SOMETHING
        //SHARE IMAGE
    }


    
    @objc func showPlusMenu(sender: UIButton!) {
        print("button Pressed")
        let storyboard = UIStoryboard(name: "PlusMenu", bundle: nil)
        let PlusMenuViewController = storyboard.instantiateViewController(withIdentifier: "PlusMenuViewController") as? PlusMenuViewController
        let vm = PlusMenuViewModel()
        PlusMenuViewController?.vm = vm
        PlusMenuViewController?.delegate = self
        PlusMenuViewController?.modalPresentationStyle = .overCurrentContext
        
        if let PlusMenuViewController = PlusMenuViewController {
            
            self.present(PlusMenuViewController, animated: true, completion: nil)
        }
    }
    


    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !(anchor is ARPlaneAnchor) {
            //수평이 아니라면 리턴
            return
        }
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        
        //같은 평면을 확장하기 위해서는 우선 발견한 모든 평면을 저장
            self.planes.append(plane)
            node.addChildNode(plane)
        
        showDetectedLabel()
        
    }
    
    func showDetectedLabel() {
        DispatchQueue.main.async {
            self.label.text = "plane detected!"
            UIView.animate(withDuration: 3.0, animations: {
                self.label.alpha = 1.0
            }, completion: { (_) in
                self.label.alpha = 0.0
            })
        }
    }
    
    // 같은 anchor를 가진 노드를 UPDATE 시켜줌
    //노드의 속성이 대응하는 anchor 와 일치하기 위해 업데이트 되었다고 알려주는 함수
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //전달된 anchor 의 identifier 가 planes에 담긴 노드 중의 anchor identifier와 같다면 해당 노드를 return하고 받은 anchor 를 통해 update 시켜줌
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first


        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    //MARK: Get Object Which is touched
    func getTouchLocation(gesture: UIGestureRecognizer) -> CGPoint {
        let sceneView = gesture.view as! ARSCNView
        return gesture.location(in: sceneView)
    }
    
    func getSelectedNode(_ touchLocation: CGPoint) -> SCNNode {
        var selectedNode: SCNNode = SCNNode()
        let hitTest = sceneView.hitTest(touchLocation)
        if !hitTest.isEmpty{
            guard let node = (hitTest.first?.node) else {
                print("CAN NOT FIND NODE")
                return selectedNode
            }
            selectedNode = node
        }
        return selectedNode
    }
    
    //MARK: Set Recognizer
    
    private func registerGestureRecognizers() {
        //put
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(putObject))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(singleTapGestureRecognizer)
        
        //delete
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeObject))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        
        //move
        let longTPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveObject))
        self.sceneView.addGestureRecognizer(longTPressGestureRecognizer)
        
        //scale
        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleObject))
        sceneView.addGestureRecognizer(scaleGesture)
        
        //pan
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(rotateObject))
        sceneView.addGestureRecognizer(panGesture)
    }

//        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            //get tep location
//            guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
//                //2. Get The Next Feature Point Etc
//                let hitTest = sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
//
//
//            //3. Convert To World Coordinates
//            let worldTransform = hitTest.worldTransform
//
//            //4. Set The New Position
//            let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
//
//            let node = getSelectedNode(currentTouchPoint)
//            //5. Apply To The Node
//
//            node.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
//
//        }

    
    @objc func moveObject(recognizer: UILongPressGestureRecognizer) {
        //get tep location
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        //1. Get The Current Touch Point
        guard let hitTest = sceneView.hitTest(touchLocation, types: .existingPlane).first else { return }
        
        
        //3. Convert To World Coordinates
        let worldTransform = hitTest.worldTransform
        
        //4. Set The New Position
        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        
        
        let node = getSelectedNode(touchLocation)
        //5. Apply To The Node
        
        node.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        
        
    }
    
    @objc func putObject(gesture: UITapGestureRecognizer) {
        //Tap 한 위치 정보 얻어냄
        let touchLocation = getTouchLocation(gesture: gesture)
        
        //hitTest(_:types:)는 탭한 위치와 대응되는 물체나 AR anchor을 찾아서 반환.
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        //만약 hitTest를 통해 얻어낸 hitResult가 empty 가 아니라면 addBox(hitResult:) 실행
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {
                print("CAN NOT DETECT PLANE")
                return
            }
            addObject(hitResult :hitResult)
        }
    }

    private func addObject(hitResult :ARHitTestResult) {

        let baseNode  = selectedNode

        //위치 지정
        //hitResult 는 많은 속성을 가지고 있는데 그 중 worldTransform.columns통해 현실에 대응하는 x, y, z 좌표를 알 수 있음

        baseNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y ,hitResult.worldTransform.columns.3.z)



        let material = SCNMaterial()
        //TODO: .dae에 직접 설정해줄 순 없는지..
        if (selectedNode.name ==  "QN65Q7FN") {
            material.roughness.contents = UIImage(named: "art.scnassets/TV/QLED/Roughness.png")
            material.metalness.contents = UIImage(named: "art.scnassets/TV/QLED/Metalic.png")
            material.normal.contents = UIImage(named: "art.scnassets/TV/QLED/Normal.png")
            material.normal.intensity = 0.5
            material.diffuse.contents = UIImage(named: "art.scnassets/TV/QLED/BaseColor.png")

            baseNode.geometry?.firstMaterial = material
        }

        //스케일 조정 - width, height, depth를 원래 크기의 0.01 만큼으로 줄여줌
        
        if (selectedNode.name ==  "PS50GAJUA" ) {
            baseNode.scale = SCNVector3(0.06,0.06,0.06) //microwave
        } else if ( selectedNode.name ==  "PI100GAJUA"){
            baseNode.scale = SCNVector3(0.01,0.01,0.01) //laptop
        } else {
            baseNode.scale = SCNVector3(0.003,0.003,0.003)
        }

        //메인 씬에 추가해줌
        self.sceneView.scene.rootNode.addChildNode(baseNode)
        selectedNodelist.append(currentSelectedItem)
    }
    
    
    @objc func removeObject(gesture: UITapGestureRecognizer) {
        let touchLocation = getTouchLocation(gesture: gesture)
        let nodeToRemove = getSelectedNode(touchLocation)
        nodeToRemove.removeFromParentNode()
       
        guard let removeIndex = selectedNodelist.firstIndex(where: {$0.model == nodeToRemove.name}) else { return }
        selectedNodelist.remove(at: removeIndex)
        
    }
    
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {
        let touchLocation = getTouchLocation(gesture: gesture)
        let nodeToScale = getSelectedNode(touchLocation)
        if gesture.state == .changed {
            let pinchScaleX: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.x))
            let pinchScaleY: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.y))
            let pinchScaleZ: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.z))
            nodeToScale.scale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
            gesture.scale = 1
        }
    }
    
    @objc func rotateObject(_ gesture: UIPanGestureRecognizer){
        
                let translation = gesture.translation(in: gesture.view!)
                var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
                newAngleY += currentAngleY
        
                let touchLocation = getTouchLocation(gesture: gesture)
        
                let nodeToScale = getSelectedNode(touchLocation)
        
                DispatchQueue.main.async {
                    nodeToScale.eulerAngles.y = newAngleY
                }
        
                if(gesture.state == .ended) { currentAngleY = newAngleY }
        
    }
}
    
    //@objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
    //
    //        //Tap 한 위치 정보 얻어냄
    //        let sceneView = gesture.view as! ARSCNView
    //        let touchLocation = gesture.location(in: sceneView)
    //
    //        //만약 hitTest를 통해 얻어낸 hitResult가 empty 가 아니라면 addBox(hitResult:) 실행
    //        let nodeToRotate = getSelectedNode(touchLocation)
    //
    //        //1. Get The Current Rotation From The Gesture
    //        let rotation = Float(gesture.rotation)
    //
    //        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
    //        if gesture.state == .changed{
    //            let temp = currentAngleY - rotation
    //            nodeToRotate.eulerAngles.y = temp < 0 ? temp * -1 : temp
    //        }
    //
    //        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
    //        if(gesture.state == .ended) {
    //            currentAngleY = nodeToRotate.eulerAngles.y
    //
    //        }
    //
    //    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        //get tep location
    //        guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
    //            //2. Get The Next Feature Point Etc
    //            let hitTest = sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
    //
    //
    //        //3. Convert To World Coordinates
    //        let worldTransform = hitTest.worldTransform
    //
    //        //4. Set The New Position
    //        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
    //
    //        let node = getSelectedNode(currentTouchPoint)
    //        //5. Apply To The Node
    //
    //        node.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
    //
    //    }


extension ViewController: SelectObjDelegate {
    func setSelectedObj(_ item: Appliance) {
        //need to set selectedOBJ
        print("cell selected: \(item.category), \(item.model) , \(item.type) ,\(item.description)")

        let baseScene = SCNScene(named: "art.scnassets/\(item.category)/\(item.type)/\(item.model).dae")

    
        guard let baseNode = baseScene?.rootNode.childNode(withName: "\(item.model)", recursively: true) else {
            print("CAN NOT FIND ASSET")
            return
        }

        selectedNode = baseNode
        currentSelectedItem = item




    }
}

import Foundation
import SceneKit
import ARKit

class OverlayPlane : SCNNode {
    
    var anchor :ARPlaneAnchor
    var planeGeometry :SCNPlane!
    
    //ARPlaneAnchor 인자로 받으면서 초기화
    init(anchor :ARPlaneAnchor) {
        
        self.anchor = anchor
        super.init()
        setup()
    }
    
    // 받아온 anchor 을 통해 geometry의 width 와 height 그리고 자신(노드)의 position 을 설정
    func update(anchor :ARPlaneAnchor) {
        
        self.planeGeometry.width = CGFloat(anchor.extent.x);
        self.planeGeometry.height = CGFloat(anchor.extent.z);
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
        
//        //MARK: Collison
//        //planeNode 에physicsBody 적용
//        //planeGeometry의 width와 height 가 계속해서 확장되기 때문에 그에 따라 physicsBody의 geometry도 업데이트 시켜줘야하기 때문
//        let planeNode = self.childNodes.first!
//        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        
    }
    
    private func setup() {
        
        //SCNPlane 생성해서 적용
    //좌표 넣어주고
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
    
    //그릴 이미저 넣어주고
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"tron_grid")
    
    //geometry와 meterial 연결
        self.planeGeometry.materials = [material]
    
    //node 90도 회전, 회전 시키는 이유는 평면이 인식되고 노드가 수직으로 추가되기 때문에 90도 돌려서 수평으로 만들어줘야함
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0)
        
//        //MARK: Collison
//        // boxNode와 충돌할 planeNode 의 physicsBody 및categoryBitMask 적용
//        //planeNode 는 충돌시 움직이지 않으므로 type 은 .static이고 계속해서 모양이 확장해나가기 때문에 shape 의 geometry 를 따로 지정
//        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
//        planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue
        
        // add to the parent
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

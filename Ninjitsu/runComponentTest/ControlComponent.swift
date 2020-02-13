//
//  ControlComponent.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/10.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ControlComponent: GKComponent, ControlDelegate {

    
    var playerController : PlayerController?
    
    var cNode : SKSpriteNode?
    
    func setup(scene: SKScene , camera: SKCameraNode) {
        playerController = PlayerController(frame: scene.frame)
        playerController?.command = self
        playerController?.position = .zero
        camera.addChild(playerController!)
        
//        if (cNode != nil) {
//            if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self){
//                cNode = (nodeComponent.node as? SKSpriteNode)!
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tryExecute() {
        print("It's working???")
    }

}

//
//  PlayerControlComponent.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/7.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerControlComponent: GKComponent {
    
    var playerControllers : PlayerControllers?
    
    func setup(scene: SKScene , camera: SKCameraNode) {
        playerControllers = PlayerControllers(frame: scene.frame)
        camera.addChild(playerControllers!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

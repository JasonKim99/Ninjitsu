//
//  AnimationComponent.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/12.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    let textures: [SKTexture]
    let spriteComponent : SpriteComponent
    var isRepeating : Bool
    
    init(entity: GKEntity , textures: [SKTexture], isRepeating : Bool) {
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        self.isRepeating = isRepeating
        super.init()
    }
    
    func startAnimate() {
        let resizeAction : SKAction = .resize(byWidth: textures[0].size().width, height: textures[0].size().height, duration: 0)
        let mainAction : SKAction = .animate(with: textures, timePerFrame: 0.1)
        let onetimeAction : SKAction = .sequence([
            resizeAction,
            mainAction
        ])
        
        let repeatAction : SKAction = .sequence([
            resizeAction,
            .repeatForever(mainAction)
        ])
        
        spriteComponent.node.removeAllActions()
        if isRepeating {
            spriteComponent.node.run(repeatAction, withKey: "animate")
        } else {
            spriteComponent.node.run(onetimeAction, withKey: "animate")
        }
            
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

//
//  CharacterEntity.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/12.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import GameplayKit
import SpriteKit

class AvatarEntity: GKEntity {
    var spriteComponent:SpriteComponent!
//    var animationComponent:AnimationComponent!
    
    
    init(avatarTexture: String) {
        super.init()
        let texture = SKTexture(imageNamed: avatarTexture)
        spriteComponent = SpriteComponent(entity: self, texture: texture)
        addComponent(spriteComponent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

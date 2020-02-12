//
//  SpriteComponent.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/12.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    let node : SKSpriteNode
    init(entity: GKEntity , texture : SKTexture) {
        node = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
        node.entity = entity
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

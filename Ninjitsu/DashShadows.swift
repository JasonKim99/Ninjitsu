//
//  DashShadows.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/2.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit

class DashShadows: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "dash1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

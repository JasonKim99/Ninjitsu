//
//  JumpButton.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/1.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    var isPressed = false {
        didSet{
            if isPressed {
                texture = SKTexture(imageNamed: "jumpbutton_pressed")
            } else {
                texture = SKTexture(imageNamed: "jumpbutton_normal")
            }
        }
    }
    
    init(buttonName: String) {
        let texture = SKTexture(imageNamed: "jumpbutton_normal")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = buttonName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

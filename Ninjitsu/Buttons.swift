//
//  Buttons.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/2.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit

class Buttons: SKSpriteNode {
    var isPressed = false {
        didSet{
            if isPressed {
                texture = SKTexture(imageNamed: "button_pressed")
            } else {
                texture = SKTexture(imageNamed: "button_normal")
            }
        }
    }
    
    init(buttonName: String) {
        let texture = SKTexture(imageNamed: "button_normal")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = buttonName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

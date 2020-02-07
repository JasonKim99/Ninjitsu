//
//  PlayerControllers.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/7.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerControllers: SKSpriteNode {
    
    let jumpButton = Buttons(buttonName: "jump" , textureName: "buttonA")
    let dashButton = Buttons(buttonName: "dash" , textureName: "buttonB")
    let ninjitsuButton = Buttons(buttonName: "ninjitsu" , textureName: "buttonY")
    let attackButton = Buttons(buttonName: "attack" , textureName: "buttonX")
    let joystick = SKSpriteNode(imageNamed: "joystick")
    let joystickKnob = SKSpriteNode(imageNamed: "knob")
    
    init(frame: CGRect) {
        super.init(texture: .none, color: .clear, size: frame.size)
        
        
        joystick.setScale(0.8)
        joystickKnob.setScale(2)
        joystick.alpha = 0.5
        joystick.addChild(joystickKnob)
        
        joystick.position = CGPoint(x: -size.width/3 , y: -size.height/4)
        addChild(joystick)
        
        
        //跳跃按钮
        jumpButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 - 80)
        jumpButton.setScale(2.5)
        jumpButton.zPosition = 10
        self.addChild(jumpButton)
        
        
        //冲刺按钮
        dashButton.position = CGPoint(x: size.width / 3 + 80 , y : -size.height/4 )
        dashButton.setScale(2.5)
        dashButton.zPosition = 1
        self.addChild(dashButton)
        
        //忍法按钮
        ninjitsuButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 + 80)
        ninjitsuButton.setScale(2.5)
        ninjitsuButton.zPosition = 1
        self.addChild(ninjitsuButton)
        
        //攻击按钮
        attackButton.position = CGPoint(x: size.width / 3 - 80 , y : -size.height/4)
        attackButton.setScale(2.5)
        attackButton.zPosition = 1
        self.addChild(attackButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

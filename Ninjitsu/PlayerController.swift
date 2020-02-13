//
//  PlayerController.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/10.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerController: SKSpriteNode {
    
    var jumpButton = Buttons(buttonName: "jump" , textureName: "buttonA")
    var dashButton = Buttons(buttonName: "dash" , textureName: "buttonB")
    var ninjitsuButton = Buttons(buttonName: "ninjitsu" , textureName: "buttonY")
    var attackButton = Buttons(buttonName: "attack" , textureName: "buttonX")
    var joystick = SKSpriteNode(imageNamed: "joystick")
    var joystickKnob = SKSpriteNode(imageNamed: "knob")
    
    var selectedNodes: [UITouch : SKSpriteNode] = [ : ]
    
    var isKnobMoving : Bool = false
    var knobRadius : CGFloat = 100
    
    var command : ControlDelegate?
    
    init(frame: CGRect) {
        super.init(texture: .none, color: .clear, size: frame.size)
        
        
        joystick = SKSpriteNode(imageNamed: "joystick")
        joystickKnob = SKSpriteNode(imageNamed: "knob")
        joystick.name = "joystick"
        joystickKnob.name = "knob"
        joystick.setScale(0.8)
        joystickKnob.setScale(2)
        joystick.alpha = 0.5
        joystick.addChild(joystickKnob)
        
        joystick.position = CGPoint(x: -size.width/3 , y: -size.height/4)
        joystick.zPosition = 10
        addChild(joystick)
        
        
        
        //跳跃按钮
        jumpButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 - 80)
        jumpButton.setScale(2.5)
        jumpButton.zPosition = 10
        addChild(jumpButton)
        
        
        //冲刺按钮
        dashButton.position = CGPoint(x: size.width / 3 + 80 , y : -size.height/4 )
        dashButton.setScale(2.5)
        dashButton.zPosition = 10
        addChild(dashButton)
        
        //忍法按钮
        ninjitsuButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 + 80)
        ninjitsuButton.setScale(2.5)
        ninjitsuButton.zPosition = 10
        addChild(ninjitsuButton)
        
        //攻击按钮
        attackButton.position = CGPoint(x: size.width / 3 - 80 , y : -size.height/4)
        attackButton.setScale(2.5)
        attackButton.zPosition = 10
        addChild(attackButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 功能
extension PlayerController{
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob.run(moveBack)
        isKnobMoving = false
    }
}


////MARK: - Touches
//extension PlayerController {
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//
//            let location = touch.location(in: parent!)
//            //如果点击摇杆
//            isKnobMoving = joystick.contains(location)
//            if isKnobMoving && !selectedNodes.values.contains(joystick){
//                selectedNodes[touch] = joystick
//                print("1")
//
//            }
//
//            //点击跳跃
//            if jumpButton.contains(location) {
//                if !selectedNodes.values.contains(jumpButton) {
//                    selectedNodes[touch] = jumpButton
//                }
////                jumpButton.isPressed = true
//                if command != nil {
//                    command!.tryExecute()
//                }
//                jumpButton.isPressed = true
//
//
//
//            }
//            if dashButton.contains(location) {
//                if !selectedNodes.values.contains(dashButton) {
//                    selectedNodes[touch] = dashButton
//                }
//                //点击冲刺
//                if command != nil {
//                    command!.tryExecute()
//                }
//                dashButton.isPressed = true
//            }
//
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        //计算距离
//        for touch in touches {
//            if let node = selectedNodes[touch] {
//                if node.name == "jump"{
//
//                } else if node.name == "dash" {
//
//                } else if node.name == "joystick"{
//                    let position = touch.location(in: joystick) //joystick里面的坐标系
//                    let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
//                    let angle = atan2(position.y, position.x)
//
//                    if knobRadius > length {
//                        joystickKnob.position = position
//                    } else {
//                        joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
//                    }
//
//
//
//                }
//            }
//
//        }
//
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //注意当scene在移动时location在不停变化
//        //        guard let joystick = joystick else { return }
//        for touch in touches {
//
//            if selectedNodes[touch] != nil {
//                if (selectedNodes[touch] == jumpButton){
//                    jumpButton.isPressed = false
//                }
//                if (selectedNodes[touch] == dashButton){
//                    dashButton.isPressed = false
//                }
//                if (selectedNodes[touch] == joystick){
//                    resetKnobPosition()
//                    isKnobMoving = false
//                }
//                selectedNodes[touch] = nil
//            }
//            //            let location = touch.location(in: self)
//            //            let preventContactAreaXPostion = dashButton.position.x - 200
//
//            //按钮旁边的位置防止误触
//            //            if location.x < preventContactAreaXPostion {
//            //                resetKnobPosition()
//            //                isKnobMoving = false
//            //            } else { isKnobMoving = true}
//            //
//            //            if jumpButton.isPressed {
//            //                jumpButton.isPressed = false
//            //            }
//            //            if dashButton.isPressed {
//            //                dashButton.isPressed = false
//            //            }
//
//        }
//
//
//    }
//}

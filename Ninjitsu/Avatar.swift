//
//  Avatar.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/6.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import SpriteKit
import GameplayKit

class Avatar : SKSpriteNode {
    
    var runSpeed : CGFloat = 8.0 //跑步速度
    
    var maxJumpForce : CGFloat = 30.0 //最大跳跃力
    var jumpCount : Int  = 2
    
    var airAccelerate : CGFloat = 0.8  //空中加速度
    var airDecelerate : CGFloat = 0.8  //减
    var groundAccelerate : CGFloat = 0.8  //地上的加速度
    var groundDecelerate : CGFloat = 0.8 //减
    
    
    //默认scale
    var dxScale : CGFloat = 1.0
    var dyScale : CGFloat = 1.0
    
    
    //dash的距离
    var dashX : CGFloat = 200.0
    var dashY : CGFloat = 120.0
    
    //dashTime
    var dashTime : TimeInterval = 0.15
    
    var hSpeed : CGFloat = 0.0  //水平速度
    var vSpeed : CGFloat { //垂直速度
        get {
            if let dy = physicsBody?.velocity.dy {
                return dy
            } else {
                return 0.0
            }
        }

    }
    
    var isInTheAir : Bool {
        get{
            if vSpeed != 0 {
                return true
            } else {
                return false
            }
        }
        set {}

    }
    
    var isMovingRight = false {
        didSet {
            if isMovingRight {
                isFacingRight = true
            }
        }
    }
    var isMovingLeft = false {
        didSet {
            if isMovingLeft {
                isFacingRight = false
            }
        }
    }
    var isFacingRight  = true {
        didSet{
            if isFacingRight {
                xScale = abs(xScale)
                dxScale = abs(dxScale)
            } else {
                xScale = -abs(xScale)
                dxScale = -abs(dxScale)
            }
        }
    }


    
    var isSpelling = false
    var isDashing = false
    



    
    
    
    init(characterName: String, texture: SKTexture, scale : CGFloat) {
        super.init(texture: texture, color: .clear, size: texture.size())
        name = characterName
        dxScale = scale
        dyScale = scale
        setPhysicBody(texture: texture)
        setScale(scale)
    }
    
    func setPhysicBody(texture: SKTexture){
        print(size)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 28, height: 45))
        zPosition = 0
        physicsBody!.isDynamic = true
        physicsBody!.affectedByGravity = true
        physicsBody!.allowsRotation = false
        physicsBody!.restitution = 0 //default 0.2 弹性
        physicsBody!.friction = 0.2 //default 0.2 摩擦力
        
        physicsBody!.categoryBitMask = CollisionType.player.mask
        physicsBody!.collisionBitMask = CollisionType.ground.mask
        physicsBody!.contactTestBitMask = CollisionType.ground.mask
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

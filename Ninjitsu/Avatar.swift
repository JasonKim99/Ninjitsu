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
    
    var stateMachine : GKStateMachine?
    
    var runSpeed : CGFloat = 8.0 //跑步速度
    
    var maxJumpForce : CGFloat = 250.0 //最大跳跃力
    var jumpCount : Int  = 2
    
    var airAccelerate : CGFloat = 0.8  //空中加速度
    var airDecelerate : CGFloat = 0.8  //减
    var groundAccelerate : CGFloat = 0.8  //地上的加速度
    var groundDecelerate : CGFloat = 0.8 //减
    
    
    //默认scale
    var dxScale : CGFloat = 1.0
    var dyScale : CGFloat = 1.0
    
    
    //dash的距离
    var dashX : CGFloat = 300.0
    var dashY : CGFloat = 150.0
    
    //dashTime
    var dashTime : TimeInterval = 0.15
    var shadowFadeOut : TimeInterval = 0.2
    
    var dSize : CGSize = .zero
    
    var hSpeed : CGFloat { //水平速度
        get {
            if let dx = physicsBody?.velocity.dx {
                return dx
            } else {
                return 0.0
            }
        }

    }
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
        set {
            
        }

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
            if !isFacingRight {
                xScale = -abs(xScale)
                dxScale = -abs(dxScale)
            } else {
                xScale = abs(xScale)
                dxScale = abs(dxScale)
            }
        }
    }


    var isSpelling = false
    var spellTimeOut = false
    var isAnimatingNinPo = false {
        didSet {
            if isAnimatingNinPo {
                endAnimateNinpo = false
            }
        }
    }
    var endAnimateNinpo = false {
        didSet {
            if endAnimateNinpo {
                isAnimatingNinPo = false
            }
        }
    }

    var isDashing = false
    
    var spellingTime : TimeInterval = 10
    var jieyin = ""
    
    
    
    
    init(characterName: String, texture: SKTexture, scale : CGFloat) {
        super.init(texture: texture, color: .clear, size: texture.size())
        name = characterName
        dSize = size
        dxScale = scale
        dyScale = scale
        setPhysicBody(texture: texture)
//        anchorPoint = CGPoint(x: 0.5, y: 0)
        setScale(scale)
        
        setupStateMachine()
    }
    
    func setPhysicBody(texture: SKTexture){
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 28, height: 45), center: .zero)
        zPosition = 0
        physicsBody!.isDynamic = true
        physicsBody!.affectedByGravity = true
        physicsBody!.allowsRotation = false
        physicsBody!.restitution = 0 //default 0.2 弹性
        physicsBody!.friction = 0 //default 0.2 摩擦力
        
        physicsBody!.categoryBitMask = CollisionType.player.mask
        physicsBody!.collisionBitMask = CollisionType.ground.mask
        physicsBody!.contactTestBitMask = CollisionType.ground.mask
        
        
    }
    
    func setupStateMachine() {
        stateMachine = GKStateMachine(states: [
            IdleState(with: self),
            RunningState(with: self),
            JumpingState(with: self),
            FallingState(with: self),
            DashingState(with: self),
            SpellingState(with: self),
            NinjitsuAnimatingState(with: self)
        ])
        stateMachine?.enter(IdleState.self)
    }
    
    func generateText(with text:String , offsetX :CGFloat , offsetY : CGFloat)  -> SKLabelNode {
        let newnode = SKLabelNode()
        newnode.position = CGPoint(x: offsetX, y: offsetY)
        newnode.zPosition = 10
        newnode.fontColor = .white
        newnode.fontName = "DFWaWaSC-W5"
        newnode.fontSize = 24
        newnode.text = text
        return newnode
    }
    
    func updateText(text: String, node: inout SKLabelNode) {
        let oldposition = node.position
        let zPositon = node.zPosition
        let xScale = node.xScale
        let yScale = node.yScale
        
        node.removeFromParent()
        
        node = generateText(with: text, offsetX: oldposition.x,offsetY: oldposition.y)
        node.zPosition = zPositon
        node.xScale = xScale
        node.yScale = yScale
        node.alpha = 1
        
        addChild(node)
    }

    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

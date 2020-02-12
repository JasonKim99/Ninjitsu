//
//  PlayerGSMachine.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/1/23.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerGSMachine: GKState {
    var frame : CGSize = CGSize(width: 1334, height: 750)
    var animateKey = "change"
    unowned var player: Avatar

    init(with player: Avatar) {
        self.player = player
        super.init()
    }
    
    func approach(start: CGFloat, end:CGFloat  , shift: CGFloat) -> CGFloat {
        if (start < end) {
            return min(start + shift , end)
        } else {
            return max(start - shift , end)
        }
    }
    
    
    func squashAndStrech(xScale: CGFloat, yScale: CGFloat) {
        player.xScale += xScale
        player.yScale += yScale
    }
    
    override func update(deltaTime seconds: TimeInterval) {

    }
}


//MARK: - 默认状态
class IdleState: PlayerGSMachine {
    var textures : [SKTexture] = (1...6).map({ return "Sasuke/Idle/Idle\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.25))
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is NinjitsuAnimatingState.Type: return false
        default: return true
        }
    }
    override func didEnter(from previousState: GKState?) {
        player.isInTheAir = false
        player.run(action, withKey: animateKey)

//        scene.jieyin = ""
//        scene.jieyin_Group.isHidden = true
//        scene.jieyin_Cancel.isHidden = true
//        scene.ninjitsuButton.isHidden = false
//
//        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))

    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if player.hSpeed != 0 {
            player.stateMachine!.enter(RunningState.self)
        }
        if player.vSpeed < 0 {
            player.stateMachine!.enter(FallingState.self)
        }

    }
    override func willExit(to nextState: GKState) {
        player.removeAction(forKey: animateKey)

    }
}

//MARK: - 跑步状态

class RunningState: PlayerGSMachine {
    let textures : [SKTexture] = (1...6).map({ return "Sasuke/Run/run\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RunningState.Type,
             is NinjitsuAnimatingState.Type,
             is SpellingState.Type: return false
        default: return true
        }
    }
    override func didEnter(from previousState: GKState?) {
        let textureWidth = textures[0].size().width
        let textureHeight = textures[0].size().height
        let wholeAction : SKAction = .sequence([
            .resize(toWidth: textureWidth, height: textureHeight, duration: 0),
            action
        ])
//        print(textureWidth)
//        print(textureHeight)
//        print(player.xScale)
//        print(player.size)
//        print(player.dSize)
        player.run(wholeAction, withKey: animateKey)

    }

    override func update(deltaTime seconds: TimeInterval) {
        

        if player.hSpeed == 0 {
            player.stateMachine!.enter(IdleState.self)
        }
        if player.vSpeed < 0 {
            
            player.stateMachine!.enter(FallingState.self)
        }
    }

    override func willExit(to nextState: GKState) {
        player.run(.resize(toWidth: player.dSize.width, height: player.dSize.height, duration: 0))
        player.removeAction(forKey: animateKey)
        

    }
}

//MARK: - 跳跃状态
class JumpingState: PlayerGSMachine {
    let textures : [SKTexture] = (1...2).map({ return "Sasuke/Jump/\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FallingState.Type,
             is SpellingState.Type,
             is JumpingState.Type,
             is DashingState.Type: return true
        default: return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        player.isInTheAir = true
        player.run(action, withKey: animateKey)
        player.run(.applyForce(CGVector(dx: 0, dy: player.maxJumpForce), duration: 0.15))
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if player.vSpeed < 0 {
            player.stateMachine!.enter(FallingState.self)
        }
    }

    override func willExit(to nextState: GKState) {
        player.removeAction(forKey: animateKey)
    }
}

//MARK: - 着陆状态

class FallingState : PlayerGSMachine {
    var textures : [SKTexture] = (1...2).map({ return "Sasuke/Fall/\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type,
             is JumpingState.Type,
             is RunningState.Type,
             is DashingState.Type: return true
        default: return false
        }
    }

    override func didEnter(from previousState: GKState?) {
        player.run(action, withKey: animateKey)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if player.vSpeed == 0 {
            if player.hSpeed == 0 {
                player.stateMachine?.enter(IdleState.self)
            } else {
                player.stateMachine?.enter(RunningState.self)
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        player.removeAction(forKey: animateKey)

    }
}


//MARK: - 冲刺状态

class DashingState: PlayerGSMachine {
    var textures : [SKTexture] = (1...6).map({ return "Sasuke/Dash/dash\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
    var shadowPool : [SKTexture] = []  //残影材质池子
    var shadowTextureIndex : Int = 0
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is SpellingState.Type, is NinjitsuAnimatingState.Type: return false
        default: return true
        }
    }
    override func didEnter(from previousState: GKState?) {
        player.isDashing = true
        player.run(action, withKey: animateKey)
        squashAndStrech(xScale: 0.6, yScale: -0.6)
        for i in 1...6 {
            let shadow = SKTexture(imageNamed: "Sasuke/Dash/dash\(i)")
            shadowPool.append(shadow)
        }
        

        //在地上以及下降时的冲刺力度
        let groundDash = SKAction.move(by: CGVector(dx: (player.isFacingRight ? player.dashX : -player.dashX), dy: 0), duration: player.dashTime)
        let liftDash = SKAction.move(by: CGVector(dx: (player.isFacingRight ? player.dashX : -player.dashX), dy: player.dashY), duration: player.dashTime)
        

        
        //施力与状态变更
        player.run(.sequence([
            player.vSpeed > 0 ? liftDash : groundDash,
            .run {
                self.player.isDashing = false
            }
        ]))


    }
    
    func addDashShadow(){
        let shadownode = SKSpriteNode(texture: shadowPool[shadowTextureIndex])
        shadownode.position = self.player.position
        shadownode.xScale = self.player.xScale
        shadownode.yScale = self.player.yScale
        shadownode.zPosition = self.player.zPosition
        player.parent!.addChild(shadownode)
        shadownode.run(.sequence([
            .fadeOut(withDuration: player.shadowFadeOut),
            .run{
                shadownode.removeFromParent()
            }
        ]))
        if shadowTextureIndex < 5 {
            shadowTextureIndex += 1
        } else {
            shadowTextureIndex = 0
        }

    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if player.isDashing {addDashShadow()} else {
            if player.vSpeed < 0 {
                player.stateMachine?.enter(FallingState.self)
            }
            if player.vSpeed == 0 {
                if player.hSpeed == 0 {
                    player.stateMachine?.enter(IdleState.self)
                } else {
                    player.stateMachine?.enter(RunningState.self)
                }
            }
        
        }
    }
    override func willExit(to nextState: GKState) {
        player.removeAction(forKey: animateKey)

    }
}



//MARK: - 结印状态

class SpellingState: PlayerGSMachine {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type, is NinjitsuAnimatingState.Type:
            return true
        default:
            return false
        }
    }
    
    lazy var timer = Timer()
    lazy var timeRemainingLabel = SKLabelNode()
    lazy var jieyinLabel  = SKLabelNode()
    var preTextures : [SKTexture] = (1...2).map({ return "Sasuke/Spell/ninpo\($0)"}).map(SKTexture.init)
    var spellTexture1 : SKTexture = .init(imageNamed: "Sasuke/Spell/ninpo3")
    var spellTexture2 : SKTexture = .init(imageNamed: "Sasuke/Spell/ninpo4")
    lazy var preaction :SKAction = .animate(with: preTextures, timePerFrame: 0.2)
    lazy var spellaction1 : SKAction = .setTexture(spellTexture1)
    lazy var spellaction2 : SKAction = .setTexture(spellTexture2)
    
    
    
    override func didEnter(from previousState: GKState?) {
        
        let pretextureWidth = preTextures[0].size().width
        let pretextureHeight = preTextures[0].size().height
        
        let wholeAction : SKAction = .sequence([
            .resize(toWidth: pretextureWidth, height: pretextureHeight, duration: 0),
            preaction
        ])
        
        
        player.run(wholeAction , withKey: animateKey)
        var timeRemaining : TimeInterval = player.spellingTime
        
        jieyinLabel = player.generateText(with: player.jieyin, offsetX: 0, offsetY: 30)
        jieyinLabel.fontSize = 12
        timeRemainingLabel = player.generateText(with: String(format: "%.1f", timeRemaining), offsetX: 150 , offsetY: 100)
        player.addChild(timeRemainingLabel)
        player.addChild(jieyinLabel)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.player.updateText(text: String(format: "%.1f",timeRemaining), node: &self.timeRemainingLabel)
            timeRemaining -= 0.1
            if timeRemaining <= 0 {
                self.player.spellTimeOut = true
                self.player.stateMachine!.enter(IdleState.self)
            }
        }
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        player.updateText(text: player.jieyin, node: &self.jieyinLabel)
        
        if ninpoDict.keys.contains(player.jieyin){
            //结印符合进行施法,进入施法阶段
            self.player.stateMachine!.enter(NinjitsuAnimatingState.self)
        }
        
         
        if player.jieyin.count > 0 {
            if player.jieyin.count % 2 == 1 {
                player.run(spellaction1)
            } else {
                player.run(spellaction2)
            }
            
        }
        


      
    }
    
    override func willExit(to nextState: GKState) {
        timer.invalidate()
//        player.removeAllChildren()
        if nextState is NinjitsuAnimatingState {
            jieyinLabel.run(.fadeOut(withDuration: 0.2))
            jieyinLabel.removeFromParent()
        } else {
            player.jieyin = ""
            jieyinLabel.removeFromParent()
        }
        
        timeRemainingLabel.removeFromParent()
        player.run(.resize(toWidth: player.dSize.width, height: player.dSize.height, duration: 0))
        player.removeAction(forKey: animateKey)
        
        
    }
    

}


//MARK: - 忍法动画状态
class NinjitsuAnimatingState: PlayerGSMachine {
    var timer = Timer()
    var ninpoLabel = SKLabelNode()
    let preTextures : [SKTexture] = (1...7).map({ return "Sasuke/Huoqiuprepare/ninpo\($0)"}).map(SKTexture.init)
    let repeatTextures: [SKTexture] = (1...9).map({ return "Sasuke/Huoqiurepeat/ninpo\($0)"}).map(SKTexture.init)
    lazy var preaction :SKAction = .animate(with: preTextures, timePerFrame: 0.2)
    lazy var repeataction : SKAction = .repeatForever(.animate(with: repeatTextures, timePerFrame: 0.2))
    lazy var fire = SKEmitterNode()
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type { return true } else { return false }
    }
    
    
    override func didEnter(from previousState: GKState?) {
        player.isAnimatingNinPo = true
        //显示忍法名称
        let ninpoNameText = ninpoDict[player.jieyin]!.element.rawValue + " • " + ninpoDict[player.jieyin]!.ninponame
        player.jieyin = ""
        ninpoLabel = player.generateText(with: ninpoNameText, offsetX: 0, offsetY: 50)
        player.addChild(ninpoLabel)
        ninpoLabel.run(.scale(by: 1, duration: 0.1))
        
        
        //动画的规格不同,所以要把默认大小和动画的大小保存下来
        let pretextureWidth = preTextures[0].size().width
        let pretextureHeight = preTextures[0].size().height
        
        
        //创建火粒子
        fire = SKEmitterNode(fileNamed: "fire1")!
        fire.zPosition = 10
 
        let wholeAction : SKAction = .sequence([
            .resize(toWidth: pretextureWidth, height: pretextureHeight, duration: 0),
            preaction,
            .group([
                repeataction,
                .run {
                    self.player.addChild(self.fire)
                    self.fire.position.x += 100
                    self.fire.run(.moveBy(x: 120, y: 0, duration: 1))
                }
            ])
        ])
        player.run(wholeAction , withKey: animateKey)

            //            let physicsBody = SKPhysicsBody(circleOfRadius: 10)
            //            fire.physicsBody = physicsBody
            //            physicsBody.affectedByGravity = false
            //            physicsBody.velocity = CGVector(dx: 100, dy: 200)
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false){_ in
            self.player.endAnimateNinpo = true
            self.player.stateMachine!.enter(IdleState.self)
        }
    }
    override func willExit(to nextState: GKState) {
        timer.invalidate()
        fire.run(.fadeOut(withDuration: 0.5))
        fire.removeFromParent()
        ninpoLabel.removeFromParent()
        player.run(.resize(toWidth: player.dSize.width, height: player.dSize.height, duration: 0))
        player.removeAction(forKey: animateKey)
        
//        self.scene.jieyin = ""
//        self.scene.ninpoLabel!.removeFromParent()
    }
    
    
    
    
    
}


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
    var textures : [SKTexture] = (1...4).map({ return "Sasuke/Idle/\($0)"}).map(SKTexture.init)
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
    let textures : [SKTexture] = (1...6).map({ return "Sasuke/Run/\($0)"}).map(SKTexture.init)
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
        player.isInTheAir = false
        player.run(action, withKey: animateKey)

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
    var preTextures : [SKTexture] = (1...2).map({ return "Sasuke/Spell/\($0)"}).map(SKTexture.init)
    var spellTexture1 : SKTexture = .init(imageNamed: "Sasuke/Spell/3")
    var spellTexture2 : SKTexture = .init(imageNamed: "Sasuke/Spell/4")
    lazy var preaction :SKAction = .animate(with: preTextures, timePerFrame: 0.2)
    lazy var spellaction1 : SKAction = .setTexture(spellTexture1)
    lazy var spellaction2 : SKAction = .setTexture(spellTexture2)
    override func didEnter(from previousState: GKState?) {
        player.run(preaction)
        jieyinLabel = player.generateText(with: player.jieyin, offsetX: 0, offsetY: 30)
        timeRemainingLabel = player.generateText(with: String(format: "%.1f", player.spellingTime), offsetX: 150 , offsetY: 100)
        player.addChild(timeRemainingLabel)
        player.addChild(jieyinLabel)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.player.updateText(text: String(format: "%.1f",self.player.spellingTime), node: &self.timeRemainingLabel)
            self.player.spellingTime -= 0.1
        }

    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if player.jieyin.count > 0 {
            if player.jieyin.count % 2 == 1 {
                player.run(spellaction1)
            } else {
                player.run(spellaction2)
            }
            
        }
        
        if ninpoDict.keys.contains(self.player.jieyin){
            //结印符合进行施法,进入施法阶段
            
            self.stateMachine!.enter(NinjitsuAnimatingState.self)
        }

       player.updateText(text: player.jieyin, node: &jieyinLabel)
    }
    
    override func willExit(to nextState: GKState) {
        timer.invalidate()
        jieyinLabel.removeFromParent()
        timeRemainingLabel.removeFromParent()
        player.jieyin = ""
        player.spellingTime = 10
//        self.scene.timeRemainingLabel!.removeFromParent()
    }
    

}


//MARK: - 忍法动画状态
class NinjitsuAnimatingState: PlayerGSMachine {
    var timer = Timer()
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type { return true } else { return false }
    }
    override func didEnter(from previousState: GKState?) {
//        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))
//        //显示忍法名称
//        let ninpoNameText = ninpoDict[scene.jieyin]!.element.rawValue + " • " + ninpoDict[scene.jieyin]!.ninponame
//        scene.ninpoLabel = scene.generateText(from: ninpoNameText, xPosition: 0, yPosition: 300)
//        scene.addChild(scene.ninpoLabel!)
//        scene.ninpoLabel?.run(.scale(by: 1.8, duration: 0.1))
//        scene.jieyin_Group.run(.fadeOut(withDuration: 0.1))
//        scene.jieyin_Cancel.run(.fadeOut(withDuration: 0.1))
//        scene.jieyin_Group.isHidden = true
//        scene.jieyin_Cancel.isHidden = true
//        scene.ninjitsuButton.isHidden = true

        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false){_ in
            self.stateMachine!.enter(IdleState.self)
        }
    }
    override func willExit(to nextState: GKState) {
        timer.invalidate()
//        self.scene.jieyin = ""
//        self.scene.ninpoLabel!.removeFromParent()
    }
}


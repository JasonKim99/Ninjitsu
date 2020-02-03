//
//  GameStateMachine.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/1/23.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import GameplayKit

class GameStateMachine: GKState {
    var animateKey = "change"
    unowned var scene: GameScene
    
    init(scene : GameScene) {
        self.scene = scene
        super.init()
    }
}

//MARK: - 默认状态
class IdleState: GameStateMachine {
    var textures : [SKTexture] = (1...4).map({ return "Sasuke/Idle/\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.25))
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is JumpingState.Type,
             is SpellingState.Type,
             is RunningState.Type,
             is DashingState.Type: return true
        default: return false
        }
    }
    override func didEnter(from previousState: GKState?) {
        scene.player!.run(action, withKey: animateKey)
        scene.jieyin = ""
        scene.isSpelling = false
        scene.jieyin_Group.isHidden = true
        scene.jieyin_Cancel.isHidden = true
        scene.ninjitsu_Button.isHidden = false
        scene.isInTheAir = false
        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))
        
    }
    override func willExit(to nextState: GKState) {
        scene.player.removeAction(forKey: animateKey)

    }
}

//MARK: - 跑步状态

class RunningState: GameStateMachine {
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
        
        scene.player!.run(action, withKey: animateKey)
    }
    
    override func willExit(to nextState: GKState) {
        scene.player.removeAction(forKey: animateKey)
    }
}

//MARK: - 跳跃状态
class JumpingState: GameStateMachine {
    var timer = Timer()
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
        
        scene.isInTheAir = true
        scene.player!.run(action, withKey: animateKey)
//        //坠落
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
//            if self.scene.player.physicsBody!.velocity.dy < 0 {
//                self.stateMachine!.enter(FallingState.self)
//            }
//        }

        
        
    }
    override func willExit(to nextState: GKState) {
        scene.player.removeAction(forKey: animateKey)
        timer.invalidate()
    }
}

//MARK: - 着陆状态

class FallingState : GameStateMachine {
    var textures : [SKTexture] = (1...2).map({ return "Sasuke/Fall/\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type,
             is JumpingState.Type,
             is DashingState.Type: return true
        default: return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.player!.run(action, withKey: animateKey)
        
    }
    override func willExit(to nextState: GKState) {
        scene.player.removeAction(forKey: animateKey)
    }
}


//MARK: - 冲刺状态

class DashingState: GameStateMachine {
    var textures : [SKTexture] = (1...6).map({ return "Sasuke/Dash/dash\($0)"}).map(SKTexture.init)
    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is SpellingState.Type, is NinjitsuAnimatingState.Type: return false
        default: return true
        }
    }
    override func didEnter(from previousState: GKState?) {
        scene.player!.run(action, withKey: animateKey)
        
    }
    override func willExit(to nextState: GKState) {
        scene.player.removeAction(forKey: animateKey)

    }
}



//MARK: - 结印状态

class SpellingState: GameStateMachine {
    var timer = Timer()
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type, is NinjitsuAnimatingState.Type:
            return true
        default:
            return false
        }
    }
    override func didEnter(from previousState: GKState?) {
        var timeRemaining : TimeInterval = 10
        scene.isSpelling = true
        scene.ninjitsu_Button.isHidden = true
        scene.jieyin_Group.isHidden = false
        scene.jieyin_Cancel.isHidden = false
        scene.jieyin_Group.run(.fadeIn(withDuration: 0.1))
        scene.jieyin_Cancel.run(.fadeIn(withDuration: 0.1))
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.scene.updateText(text: String(format: "%.1f", timeRemaining), node: &self.scene.timeRemainingLabel!)
            timeRemaining -= 0.1
            if timeRemaining > 0 {
                if ninpoDict.keys.contains(self.scene.jieyin){
                    //结印符合进行施法,进入施法阶段
                    self.stateMachine!.enter(NinjitsuAnimatingState.self)
                }
            } else {self.stateMachine!.enter(IdleState.self)}
        }

    }
    override func willExit(to nextState: GKState) {
        timer.invalidate()
        self.scene.timeRemainingLabel!.removeFromParent()
    }
    
}


//MARK: - 忍法动画状态
class NinjitsuAnimatingState: GameStateMachine {
    var timer = Timer()
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type { return true } else { return false }
    }
    override func didEnter(from previousState: GKState?) {
        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))
        //显示忍法名称
        let ninpoNameText = ninpoDict[scene.jieyin]!.element.rawValue + " • " + ninpoDict[scene.jieyin]!.ninponame
        scene.ninpoLabel = scene.generateText(from: ninpoNameText, xPosition: 0, yPosition: 300)
        scene.addChild(scene.ninpoLabel!)
        scene.ninpoLabel?.run(.scale(by: 1.8, duration: 0.1))
        scene.jieyin_Group.run(.fadeOut(withDuration: 0.1))
        scene.jieyin_Cancel.run(.fadeOut(withDuration: 0.1))
        scene.jieyin_Group.isHidden = true
        scene.jieyin_Cancel.isHidden = true
        scene.ninjitsu_Button.isHidden = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false){_ in
            self.stateMachine!.enter(IdleState.self)
        }
    }
    override func willExit(to nextState: GKState) {
        timer.invalidate()
        self.scene.jieyin = ""
        self.scene.ninpoLabel!.removeFromParent()
    }
}


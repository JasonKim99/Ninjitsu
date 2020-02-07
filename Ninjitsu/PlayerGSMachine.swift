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
}


class GroundMovingState: PlayerGSMachine {
    var idleTextures : [SKTexture] = (1...4).map({ return "Sasuke/Idle/\($0)"}).map(SKTexture.init)
    var runTextures : [SKTexture] = (1...6).map({ return "Sasuke/Run/\($0)"}).map(SKTexture.init)
    lazy var idleAction :SKAction = .repeatForever(.animate(with: idleTextures, timePerFrame: 0.25))
    lazy var runAction :SKAction = .repeatForever(.animate(with: runTextures, timePerFrame: 0.25))
    
    override func didEnter(from previousState: GKState?) {
        
    }
    override func update(deltaTime seconds: TimeInterval) {
        if player.isMovingRight {
            player.hSpeed = player.runSpeed
        } else if player.isMovingLeft {
            player.hSpeed = -player.runSpeed
        } else {
            player.hSpeed = 0
        }
        player.position.x = player.position.x + player.hSpeed
    }
}


////MARK: - 默认状态
//class IdleState: PlayerGSMachine {
//    var textures : [SKTexture] = (1...4).map({ return "Sasuke/Idle/\($0)"}).map(SKTexture.init)
//    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.25))
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        switch stateClass {
//        case is JumpingState.Type,
//             is SpellingState.Type,
//             is RunningState.Type,
//             is DashingState.Type: return true
//        default: return false
//        }
//    }
//    override func didEnter(from previousState: GKState?) {
//        player.run(action, withKey: animateKey)
//
//        player.isSpelling = false
//        player.isInTheAir = false
////        scene.jieyin = ""
////        scene.jieyin_Group.isHidden = true
////        scene.jieyin_Cancel.isHidden = true
////        scene.ninjitsuButton.isHidden = false
////
////        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))
//
//    }
//    override func willExit(to nextState: GKState) {
//        player.removeAction(forKey: animateKey)
//
//    }
//}
//
////MARK: - 跑步状态
//
//class RunningState: PlayerGSMachine {
//    let textures : [SKTexture] = (1...6).map({ return "Sasuke/Run/\($0)"}).map(SKTexture.init)
//    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        switch stateClass {
//        case is RunningState.Type,
//             is NinjitsuAnimatingState.Type,
//             is SpellingState.Type: return false
//        default: return true
//        }
//    }
//    override func didEnter(from previousState: GKState?) {
//        player.run(action, withKey: animateKey)
//
//    }
//

//
//    override func willExit(to nextState: GKState) {
//        player.removeAction(forKey: animateKey)
//    }
//}
//
////MARK: - 跳跃状态
//class JumpingState: PlayerGSMachine {
//    let textures : [SKTexture] = (1...2).map({ return "Sasuke/Jump/\($0)"}).map(SKTexture.init)
//    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        switch stateClass {
//        case is FallingState.Type,
//             is SpellingState.Type,
//             is JumpingState.Type,
//             is DashingState.Type: return true
//        default: return false
//        }
//    }
//
//    override func didEnter(from previousState: GKState?) {
//        player.isInTheAir = true
//        player.run(action, withKey: animateKey)
////        squashAndStrech(xScale: -0.5, yScale: 0.5)
//        player.run(.applyImpulse(CGVector(dx: 0, dy: player.maxJumpForce), duration: 0.1))
//    }
//
//    override func willExit(to nextState: GKState) {
//        player.removeAction(forKey: animateKey)
//    }
//}
//
////MARK: - 着陆状态
//
//class FallingState : PlayerGSMachine {
//    var textures : [SKTexture] = (1...2).map({ return "Sasuke/Fall/\($0)"}).map(SKTexture.init)
//    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        switch stateClass {
//        case is IdleState.Type,
//             is JumpingState.Type,
//             is DashingState.Type: return true
//        default: return false
//        }
//    }
//
//    override func didEnter(from previousState: GKState?) {
//        player.run(action, withKey: animateKey)
//
//    }
//    override func willExit(to nextState: GKState) {
//        player.removeAction(forKey: animateKey)
//
//    }
//}
//
//
////MARK: - 冲刺状态
//
//class DashingState: PlayerGSMachine {
//    var textures : [SKTexture] = (1...6).map({ return "Sasuke/Dash/dash\($0)"}).map(SKTexture.init)
//    lazy var action :SKAction = .repeatForever(.animate(with: textures, timePerFrame: 0.1))
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        switch stateClass {
//        case is SpellingState.Type, is NinjitsuAnimatingState.Type: return false
//        default: return true
//        }
//    }
//    override func didEnter(from previousState: GKState?) {
//        player.isDashing = true
//        player.run(action, withKey: animateKey)
//
//        //在地上以及下降时的冲刺力度
//        let groundDash = SKAction.move(by: CGVector(dx: (player.isFacingRight ? player.dashX : -player.dashX), dy: 0), duration: player.dashTime)
//        let liftDash = SKAction.move(by: CGVector(dx: (player.isFacingRight ? player.dashX : -player.dashX), dy: player.dashY), duration: player.dashTime)
//
//        //施力与状态变更
//        player.run(.sequence([
//            player.isInTheAir && player.physicsBody!.velocity.dy > 0 ? liftDash : groundDash,
//            .run {
//                self.player.isDashing = false
//            }
//        ]))
//
//    }
//    override func willExit(to nextState: GKState) {
//        player.removeAction(forKey: animateKey)
//
//    }
//}
//
//
//
////MARK: - 结印状态
//
//class SpellingState: PlayerGSMachine {
//    var timer = Timer()
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        switch stateClass {
//        case is IdleState.Type, is NinjitsuAnimatingState.Type:
//            return true
//        default:
//            return false
//        }
//    }
//    override func didEnter(from previousState: GKState?) {
////        var timeRemaining : TimeInterval = 10
//        player.isSpelling = true
////        scene.ninjitsuButton.isHidden = true
////        scene.jieyin_Group.isHidden = false
////        scene.jieyin_Cancel.isHidden = false
////        scene.jieyin_Group.run(.fadeIn(withDuration: 0.1))
////        scene.jieyin_Cancel.run(.fadeIn(withDuration: 0.1))
////        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
////            self.scene.updateText(text: String(format: "%.1f", timeRemaining), node: &self.scene.timeRemainingLabel!)
////            timeRemaining -= 0.1
////            if timeRemaining > 0 {
////                if ninpoDict.keys.contains(self.scene.jieyin){
////                    //结印符合进行施法,进入施法阶段
////                    self.stateMachine!.enter(NinjitsuAnimatingState.self)
////                }
////            } else {self.stateMachine!.enter(IdleState.self)}
////        }
//
//    }
//    override func willExit(to nextState: GKState) {
//        timer.invalidate()
////        self.scene.timeRemainingLabel!.removeFromParent()
//    }
//
//}
//
//
////MARK: - 忍法动画状态
//class NinjitsuAnimatingState: PlayerGSMachine {
//    var timer = Timer()
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        if stateClass is IdleState.Type { return true } else { return false }
//    }
//    override func didEnter(from previousState: GKState?) {
////        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))
////        //显示忍法名称
////        let ninpoNameText = ninpoDict[scene.jieyin]!.element.rawValue + " • " + ninpoDict[scene.jieyin]!.ninponame
////        scene.ninpoLabel = scene.generateText(from: ninpoNameText, xPosition: 0, yPosition: 300)
////        scene.addChild(scene.ninpoLabel!)
////        scene.ninpoLabel?.run(.scale(by: 1.8, duration: 0.1))
////        scene.jieyin_Group.run(.fadeOut(withDuration: 0.1))
////        scene.jieyin_Cancel.run(.fadeOut(withDuration: 0.1))
////        scene.jieyin_Group.isHidden = true
////        scene.jieyin_Cancel.isHidden = true
////        scene.ninjitsuButton.isHidden = true
//
//        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false){_ in
//            self.stateMachine!.enter(IdleState.self)
//        }
//    }
//    override func willExit(to nextState: GKState) {
//        timer.invalidate()
////        self.scene.jieyin = ""
////        self.scene.ninpoLabel!.removeFromParent()
//    }
//}
//

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
    unowned var scene: GameScene
    
    init(scene : GameScene) {
        self.scene = scene
        super.init()
    }
}

//MARK: - 默认状态
class DefaultState: GameStateMachine {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is SpellingState.Type { return true } else { return false }
    }
    override func didEnter(from previousState: GKState?) {
        scene.jieyin = ""
        scene.isSpelling = false
        scene.jieyin_Group.isHidden = true
        scene.jieyin_Cancel.isHidden = true
        scene.ninjitsu_Button.isHidden = false
        scene.jieyinLabel?.run(.fadeOut(withDuration: 0.2))
        
    }
    override func willExit(to nextState: GKState) {

    }
}

//MARK: - 结印状态

class SpellingState: GameStateMachine {
    var timer = Timer()
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DefaultState.Type, is NinjitsuAnimatingState.Type:
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
            } else {self.stateMachine!.enter(DefaultState.self)}
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
        if stateClass is DefaultState.Type { return true } else { return false }
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
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false){_ in
            self.scene.jieyin = ""
            self.scene.ninpoLabel!.removeFromParent()
            self.stateMachine!.enter(DefaultState.self)
        }
    }
    override func willExit(to nextState: GKState) {
        timer.invalidate()
    }
}


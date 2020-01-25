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
        
        scene.isSpelling = false
        scene.jieyin_Cancel.run(.fadeOut(withDuration: 0.1))
        scene.jieyin_Group.run(.fadeOut(withDuration: 0.1))
        scene.jieyin_Group.isHidden = true
        scene.jieyin_Cancel.isHidden = true
        scene.ninjitsu_Button.isHidden = false
        scene.ninjitsu_Button.alpha = 0
        scene.ninjitsu_Button.run(.fadeIn(withDuration: 0.1))
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
}

//MARK: - 结印状态

class SpellingState: GameStateMachine {
    var spellingTime : TimeInterval = 10
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DefaultState.Type, is NinjitsuAnimatingState.Type:
            return true
        default:
            return false
        }
    }
    override func didEnter(from previousState: GKState?) {

        scene.isSpelling = true
        scene.ninjitsu_Button.isHidden = true
        scene.jieyin_Group.isHidden = false
        scene.jieyin_Cancel.isHidden = false
        scene.jieyin_Group.run(.fadeIn(withDuration: 0.1))
        scene.jieyin_Cancel.run(.fadeIn(withDuration: 0.1))
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
//            if self.spellingTime > 0 {
//                self.scene.updateText(text: String(self.spellingTime), node: &self.scene.spellingTimeLabel!)
//                self.spellingTime -= 1
//            } else {
//                self.scene.spellingTimeLabel?.removeFromParent()
//                self.stateMachine?.enter(DefaultState.self)
//            }
//
//        }
    }
}


//MARK: - 忍法动画状态
class NinjitsuAnimatingState: GameStateMachine {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is DefaultState.Type { return true } else { return false }
    }
    override func didEnter(from previousState: GKState?) {
        scene.jieyin_Group.run(.fadeOut(withDuration: 0.1))
        scene.jieyin_Cancel.run(.fadeOut(withDuration: 0.1))
        scene.jieyin_Group.isHidden = true
        scene.jieyin_Cancel.isHidden = true
        scene.ninjitsu_Button.isHidden = true
    }
}


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
    unowned var jieyin_Group : SKNode
    unowned var ninjitsu_Button : SKNode
    unowned var jieyin_Cancel : SKNode
    
    init(jieyin_Group: SKNode, ninjitsu_Button : SKNode, jieyin_Cancel : SKNode) {
        self.jieyin_Group = jieyin_Group
        self.ninjitsu_Button = ninjitsu_Button
        self.jieyin_Cancel = jieyin_Cancel
        super.init()
    }
}

//MARK: - 默认状态
class DefaultState: GameStateMachine {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is SpellingState.Type { return true } else { return false }
    }
    override func didEnter(from previousState: GKState?) {
        jieyin_Cancel.run(.fadeOut(withDuration: 0.1))
        jieyin_Group.run(.fadeOut(withDuration: 0.1))
        ninjitsu_Button.run(.fadeIn(withDuration: 0.1))
    }
}

//MARK: - 结印状态

class SpellingState: GameStateMachine {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DefaultState.Type, is NinjitsuAnimatingState.Type:
            return true
        default:
            return false
        }
    }
    override func didEnter(from previousState: GKState?) {
        ninjitsu_Button.run(.fadeOut(withDuration: 0.1))
        jieyin_Group.run(.fadeIn(withDuration: 0.1))
        jieyin_Cancel.run(.fadeIn(withDuration: 0.1))
    }
}


//MARK: - 忍法动画状态
class NinjitsuAnimatingState: GameStateMachine {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is DefaultState.Type { return true } else { return false }
    }
    override func didEnter(from previousState: GKState?) {
        
    }
}


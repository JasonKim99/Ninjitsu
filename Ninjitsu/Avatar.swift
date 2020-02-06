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
    
    var isMovingRight = true
    var isMovingLeft = false
    var isFacingRight = true
    var isFacingLeft = false
    
    var hSpeed : CGFloat = 0.0  //水平速度
    var runSpeed : CGFloat = 0.0 //跑步速度
    
    
    var playerStateMachine : GKStateMachine?
    
    func setUpStateMachine(){
        playerStateMachine = GKStateMachine(states: [NormalState(with: self)])
        playerStateMachine?.enter(NormalState.self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

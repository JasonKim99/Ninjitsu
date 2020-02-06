//
//  NormalState.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/6.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import GameplayKit

class NormalState: GKState {
    var avatar : Avatar
    
    init(with avatar: Avatar) {
        self.avatar = avatar
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if avatar.isMovingRight {
            avatar.hSpeed = avatar.runSpeed
        } else if avatar.isMovingLeft {
            avatar.hSpeed = -avatar.runSpeed
        } else {
            avatar.hSpeed = 0
        }
        avatar.position.x = avatar.position.x + avatar.hSpeed
    }
}

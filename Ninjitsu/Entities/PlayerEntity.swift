//
//  PlayerEntity.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/12.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerEntity: AvatarEntity {
    
    var playerName : String
    
    var animationComponent : AnimationComponent!
    
    let playerGSMachine = PlayerGSMachine.self
    
    init(characterName : String) {
        playerName = characterName
        let avatarTexture = "\(playerName)/Idle/Idle1"
        super.init(avatarTexture: avatarTexture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

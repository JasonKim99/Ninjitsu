//
//  Collision.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/2/6.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
enum CollisionType: UInt32 {
    case player = 1
    case ground = 2
    
    var mask: UInt32 {
        return rawValue
    }
}

struct Collision {
    
    let masks: (first : UInt32 , second: UInt32)
    
    func matches (_ first: CollisionType, _ second: CollisionType) -> Bool {
        return (first.mask == masks.first && second.mask == masks.second) ||
            (first.mask == masks.second && second.mask == masks.first)
    }
    
}

//
//  YinShi.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/1/23.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit

class Yinshi: SKNode {
    var yin : String!
    
    init(yin: String) {
        self.yin = "jieyin_" + yin
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

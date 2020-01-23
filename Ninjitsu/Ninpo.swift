//
//  Ninpo.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/1/23.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import Foundation
import SpriteKit

class Ninpo {
    var jieyin : String
    
    init(jieyin: String) {
        self.jieyin = jieyin
    }
    
    func isJieyinRight() -> Bool {
        return true
    }
}

enum Element: String {
    case Shui = "水遁"
    case Huo = "火遁"
    case Feng = "风遁"
    case Tu = "土遁"
    case Lei = "雷遁"
}

//enum Ninjitsu: String{
//
//}

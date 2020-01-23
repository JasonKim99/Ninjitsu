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
    var isConverToNinpo : Bool {
        if ninpoDict.keys.contains(jieyin) {
            return true
        }
        return false
    }
    
    init(jieyin: String) {
        self.jieyin = jieyin
    }
    
}

enum Element: String {
    case Shui = "水遁"
    case Huo = "火遁"
    case Feng = "风遁"
    case Tu = "土遁"
    case Lei = "雷遁"
}

var ninpoDict : [String : (element: Element, ninponame: String)] = [
    "子丑" : (element: .Huo, ninponame: "火球の术")
]
//enum Ninjitsu: String{
//
//}

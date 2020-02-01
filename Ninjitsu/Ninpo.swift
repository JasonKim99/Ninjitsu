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
    static var jieyin : String = ""
    var isConvertableToNinpo : Bool {
        if ninpoDict.keys.contains(Ninpo.jieyin) {
            return true
        }
        return false
    }
    
    init(jieyin: String) {
        Ninpo.self.jieyin = jieyin
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
    "巳未申亥午寅" : (element: .Huo, ninponame: "豪火球の术"),
    "寅巳寅巳寅巳" : (element: .Shui, ninponame: "水阵壁")
]
//enum Ninjitsu: String{
//
//}

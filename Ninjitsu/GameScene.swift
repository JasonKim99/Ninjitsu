//
//  GameScene.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/1/22.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Nodes
    var ninjitsu_Button : SKNode! //忍法按钮
    var jieyin_Cancel : SKNode! //取消施法按钮
    var jieyin_Group : SKNode! //印式矩阵
    var zi : SKNode!
    var chou : SKNode!
    var yin : SKNode!
    var mao : SKNode!
    var chen  : SKNode!
    var si : SKNode!
    var wu : SKNode!
    var wei : SKNode!
    var shen : SKNode!
    var you : SKNode!
    var xu : SKNode!
    var hai : SKNode!
    var jieyinLabel : SKLabelNode?
    var ninpoLabel : SKLabelNode?
    
    //stats
    var twelveYin :[SKNode? : String] = [:]
    var jieyin = ""
    
    
    
    //Bool
    var isSpelling = false //是否在吟唱中
    
    
    //GameState
    var gameStateMachine : GKStateMachine!
    
    override func didMove(to view: SKView) {
        
        loadUI()
        
        gameStateMachine = GKStateMachine(states: [
            DefaultState(jieyin_Group: jieyin_Group, ninjitsu_Button : ninjitsu_Button, jieyin_Cancel : jieyin_Cancel),
            SpellingState(jieyin_Group: jieyin_Group, ninjitsu_Button : ninjitsu_Button, jieyin_Cancel : jieyin_Cancel),
            NinjitsuAnimatingState(jieyin_Group: jieyin_Group, ninjitsu_Button : ninjitsu_Button, jieyin_Cancel : jieyin_Cancel)
        ])
        
        gameStateMachine.enter(DefaultState.self)

    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

//MARK: - LoadUI

extension GameScene {
    func loadUI(){
        ninjitsu_Button = childNode(withName: "ninjitsu_Button")
        jieyin_Group = childNode(withName: "jieyin_Group")
        jieyin_Group.isHidden = true
        jieyin_Cancel = childNode(withName: "jieyin_Cancel")
        zi = jieyin_Group.childNode(withName: "jieyin_zi")!
        chou = jieyin_Group.childNode(withName: "jieyin_chou")!
        yin = jieyin_Group.childNode(withName: "jieyin_yin")!
        mao = jieyin_Group.childNode(withName: "jieyin_mao")!
        chen  = jieyin_Group.childNode(withName: "jieyin_chen")!
        si = jieyin_Group.childNode(withName: "jieyin_si")!
        wu = jieyin_Group.childNode(withName: "jieyin_wu")!
        wei = jieyin_Group.childNode(withName: "jieyin_wei")!
        shen = jieyin_Group.childNode(withName: "jieyin_shen")!
        you = jieyin_Group.childNode(withName: "jieyin_you")!
        xu = jieyin_Group.childNode(withName: "jieyin_xu")!
        hai = jieyin_Group.childNode(withName: "jieyin_hai")!
        twelveYin = [zi : "子", chou : "丑", yin : "寅", mao : "卯", chen : "辰", si : "巳", wu : "午", wei : "未", shen : "申", you : "酉", xu : "戌", hai :"亥"]
        jieyinLabel = generateText(from: jieyin, xPosition: 0, yPosition: 200)
    }
}


//MARK: - Touches
extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let ninjitsu_Button = ninjitsu_Button else {return}
//        guard let jieyin_Group = jieyin_Group else {return}
//        guard let jieyin_Cancel = jieyin_Cancel else {return}
        for touch in touches {
            let location = touch.location(in: self)
            
            //开始结印
            if ninjitsu_Button.contains(location) && !isSpelling {
                gameStateMachine.enter(SpellingState.self)
                isSpelling = true
            }
            //结印ing
            if isSpelling {
                for yinshi in twelveYin {
                    if yinshi.key!.contains(location) {
                        jieyin += yinshi.value
                        
                    }
                }
                //显示结印内容
                updateText(text: jieyin, node: &jieyinLabel!)
            }

            //是否取消了结印
            if jieyin_Cancel.contains(location) && jieyin_Cancel.alpha == 1{
                gameStateMachine.enter(DefaultState.self)

                isSpelling = false
                jieyin = ""
                jieyinLabel?.run(.fadeOut(withDuration: 0.2))
            }
            
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if ninpoDict.keys.contains(jieyin) && isSpelling {
            //结印符合进行施法
            isSpelling = false
            gameStateMachine.enter(NinjitsuAnimatingState.self)
            jieyinLabel?.run(.fadeOut(withDuration: 0.2))
            //显示忍法名称
            var ninpoNameText = ninpoDict[jieyin]!.element.rawValue + " • " + ninpoDict[jieyin]!.ninponame
            ninpoLabel = generateText(from: ninpoNameText, xPosition: 0, yPosition: 300)
            addChild(ninpoLabel!)
            ninpoLabel?.run(.scale(by: 1.5, duration: 0.2))
            Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false){_ in
                ninpoNameText = ""
                self.jieyin = ""
                self.ninpoLabel!.removeFromParent()
                self.gameStateMachine.enter(DefaultState.self)
            }
            
        }

    }
    
    
}

//MARK: - Action
extension GameScene {
    
    //显示结印
    func generateText(from text:String, xPosition: CGFloat, yPosition: CGFloat)  -> SKLabelNode {
        let newnode = SKLabelNode()
        newnode.position = CGPoint(x: xPosition, y: yPosition)
        newnode.fontColor = .white
        newnode.fontName = "WawaSC-Regular"
        newnode.fontSize = 32
        newnode.text = text
        return newnode
    }

    //实时更新显示的结印
    func updateText(text: String, node: inout SKLabelNode) {
        let position = node.position
        let xPosition = position.x
        let yPosition = position.y
        let zPositon = node.zPosition
        let xScale = node.xScale
        let yScale = node.yScale

        node.removeFromParent()

        node = generateText(from: text, xPosition: xPosition, yPosition: yPosition)
        node.position = position
        node.zPosition = zPositon
        node.xScale = xScale
        node.yScale = yScale
        node.alpha = 1

        addChild(node)
    }
}

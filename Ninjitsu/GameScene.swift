//
//  GameScene.swift
//  Ninjitsu
//
//  Created by Jason Kim on 2020/1/22.
//  Copyright © 2020 Jason Kim. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit


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
    var timeRemainingLabel : SKLabelNode?
    //stats
    var twelveYin :[SKNode? : String] = [:]
    var jieyin = ""
    var timeRemaining : TimeInterval = 10
    var player : SKSpriteNode?
    
    //Bool
    var isSpelling = false //是否在吟唱中
    
    
    //GameState
    var gameStateMachine : GKStateMachine!
    
    override func didMove(to view: SKView) {
        
        loadUI()
        
        gameStateMachine = GKStateMachine(states: [
            DefaultState(scene: self),
            SpellingState( scene: self),
            NinjitsuAnimatingState(scene: self)
        ])
        
        gameStateMachine.enter(DefaultState.self)
        
//        查询字体名字
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
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
        
        //结印Label
        jieyinLabel = generateText(from: jieyin, xPosition: 0, yPosition: 200)
        
        //倒计时Label
        timeRemainingLabel = generateText(from: String(timeRemaining), xPosition: 0, yPosition: 350)
        
        
        
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
            
            
            
            if gameStateMachine.currentState is DefaultState {
                //默认状态
                
                //如果点击忍法
                if ninjitsu_Button.contains(location){
                    gameStateMachine.enter(SpellingState.self)
                    
                }
            } else if gameStateMachine.currentState is SpellingState {
                //结印中
                
                //如果点击到印式,存下来
                for yinshi in twelveYin {
                    if yinshi.key!.contains(location) {
                        jieyin += yinshi.value
                    }
                }
                
                //如果点到了取消按钮,返回默认状态
                if jieyin_Cancel.contains(location) {
                    gameStateMachine.enter(DefaultState.self)
                }
                
                //每次点击更新所节的印
                updateText(text: jieyin, node: &jieyinLabel!)
            }
            
            
        }
//        addfire()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
}

//MARK: - Action
extension GameScene {
    
    //显示结印
    func generateText(from text:String, xPosition: CGFloat, yPosition: CGFloat)  -> SKLabelNode {
        let newnode = SKLabelNode()
        newnode.position = CGPoint(x: xPosition, y: yPosition)
        newnode.fontColor = .white
        newnode.fontName = "DFWaWaSC-W5"
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
    
    func addSasuke()->SKSpriteNode{
        var textureArray :[SKTexture] = []
        for i in 1...4{
            textureArray.append(SKTexture.init(imageNamed: "Idle\(i)"))
        }
        
        let node = SKSpriteNode(texture: textureArray[0])
        node.size = CGSize(width: 60, height: 60)
        node.position = CGPoint(x: -300, y: 0)
        node.xScale = 2
        node.yScale = 2
        node.run(.repeatForever(.animate(with: textureArray, timePerFrame: 0.2)))
        return node
        
    }
    
    func addperformNinpo(from node: inout SKSpriteNode){
        
        //新动画
        var textureArray :[SKTexture] = []
        for i in 1...4{
            textureArray.append(SKTexture.init(imageNamed: "Ninpo\(i)"))
        }
        
        //node的改动
        let size = node.size
        let position = node.position
//        let zPosition = node.zPosition
//        let xScale = node.xScale
//        let yScale = node.yScale
        node.removeFromParent()
        
        node = SKSpriteNode(texture: textureArray[0])
        node.size = size
        node.position = position
//        newnode.zPosition = zPosition
        node.xScale = xScale
        node.yScale = yScale
        addChild(node)
        
        node.run(.sequence([
            .animate(with: textureArray, timePerFrame: 0.15),
            .run {
                self.addfire()
            }
        ])
        )

    }
    
    
    
    func addfire(){
        if let fire = SKEmitterNode(fileNamed: "fire1") {
            fire.position = CGPoint(x: -120, y: .zero)
            fire.zPosition = 5
            let physicsBody = SKPhysicsBody(circleOfRadius: 10)
            fire.physicsBody = physicsBody
            physicsBody.affectedByGravity = false
//            physicsBody.velocity = CGVector(dx: 100, dy: 200)
            
            addChild(fire)
            fire.run(.sequence([
                .moveTo(x: 300, duration: 1),
                .wait(forDuration: 2),
                .fadeOut(withDuration: 0.5),
                .removeFromParent()
            ]))
            

            
        }
    }
    

    
//    func animateNinpo() {
//        let textureAtlas = SKTextureAtlas(named: "Gaara")
//        var textureArray = [SKTexture]()
//        for i in 1...textureAtlas.textureNames.count{
//            let name = "test\(i).png"
//            textureArray.append(SKTexture(imageNamed: name))
//        }
//
//
//
//        var texture = Array<SKTexture>()
//        var texture1 = Array<SKTexture>()
//        let gaara = UIImage(named:"Gaara")!
//
//        let gaaracropped1 = gaara.cgImage?.cropping(to: CGRect(x: 439, y: 512-213, width: 36, height: 76))
//        let gaaracropped2 = gaara.cgImage?.cropping(to: CGRect(x: 390, y: 512-(275+76), width: 36, height: 76))
//        let gaaracropped3 = gaara.cgImage?.cropping(to: CGRect(x: 352, y: 512-(275+76), width: 36, height: 76))
//        let gaaracropped4 = gaara.cgImage?.cropping(to: CGRect(x: 496, y: 512-(2+76), width: 36, height: 76))
//        let gaaracropped5 = gaara.cgImage?.cropping(to: CGRect(x: 458, y: 512-(2+76), width: 36, height: 76))
//        let gaaracropped6 = gaara.cgImage?.cropping(to: CGRect(x: 401, y: 512-(140+76), width: 36, height: 76))
//        texture.append( SKTexture.init(cgImage: gaaracropped1!))
//        texture.append( SKTexture.init(cgImage: gaaracropped2!))
//        texture.append( SKTexture.init(cgImage: gaaracropped3!))
//        texture.append( SKTexture.init(cgImage: gaaracropped4!))
//        texture.append( SKTexture.init(cgImage: gaaracropped5!))
//        texture.append( SKTexture.init(cgImage: gaaracropped6!))
//
//        let testnode = SKSpriteNode(texture: SKTexture.init(cgImage: gaaracropped1!))
//        testnode.setScale(2)
//        testnode.position = CGPoint(x: -200 , y:.zero)
//        addChild(testnode)
//        testnode.run(.repeatForever(.animate(with: texture, timePerFrame: 0.1)))
//
//        let skillcropped1 = gaara.cgImage?.cropping(to: CGRect(x: 379, y: 512-(76+2), width: 36, height: 76))
//        let skillcropped2 = gaara.cgImage?.cropping(to: CGRect(x: 336, y: 512-(76+2), width: 36, height: 76))
//        let skillcropped3 = gaara.cgImage?.cropping(to: CGRect(x: 352, y: 512-(76+140), width: 36, height: 76))
//        let skillcropped4 = gaara.cgImage?.cropping(to: CGRect(x: 420, y: 512-(76+2), width: 36, height: 76))
//        texture1.append(SKTexture.init(cgImage: skillcropped1!))
//        texture1.append(SKTexture.init(cgImage: skillcropped2!))
//        texture1.append(SKTexture.init(cgImage: skillcropped3!))
//        texture1.append(SKTexture.init(cgImage: skillcropped4!))
//
//        let testnode1 = SKSpriteNode(texture: SKTexture.init(cgImage: skillcropped1!))
//        testnode1.setScale(2)
//        testnode1.position = CGPoint(x: 200 , y:.zero)
//        addChild(testnode1)
//        testnode1.run(.repeatForever(.animate(with: texture1, timePerFrame: 0.1)))
//
//
//    }
    
}


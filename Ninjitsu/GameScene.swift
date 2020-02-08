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
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    //Nodes
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
    var joystick: SKSpriteNode?
    var joystickKnob: SKSpriteNode?
    let jumpButton = Buttons(buttonName: "jump" , textureName: "buttonA")
    let dashButton = Buttons(buttonName: "dash" , textureName: "buttonB")
    let ninjitsuButton = Buttons(buttonName: "ninjitsu" , textureName: "buttonY")
    let attackButton = Buttons(buttonName: "attack" , textureName: "buttonX")
    var player : Avatar!
    var cameraNode : SKCameraNode?
    var shadowPool : [SKTexture] = []
    var shadowTextureIndex : Int = 0
//    var controllers : PlayerControllers?
    
    //stats
    var twelveYin :[SKNode? : String] = [:]
    var jieyin = ""
    var spellTimeRemaining : TimeInterval = 10 //结印倒计时
    var knobRadius : CGFloat = 100 //摇杆半径
    var difference : (CGFloat, CGFloat)?
    var previousTimeInterval : TimeInterval = 0
    let dashCoolDown : TimeInterval = 3
    var dashTimeLeft : TimeInterval = 0
    
    //Bool
    var isKnobMoving = false //是否在控制摇杆
    
    //Touches
    var selectedNodes: [UITouch : SKSpriteNode] = [ : ]
    
    //GameState
//    var player.stateMachine! : GKStateMachine!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        
        loadUI()
        
//        if let testplayer = childNode(withName: "testplayer") {
//            print("its")
//            if let testcomponent = testplayer.entity?.component(ofType: PlayerControlComponent.self) {
//                print("working")
//                testcomponent.setup(scene: self, camera: cameraNode!)
//            }
//        }
        
//        player.stateMachine! = GKStateMachine(states: [
//            IdleState(with: player),
//            RunningState(with: player),
//            JumpingState(with: player),
//            FallingState(with: player),
//            DashingState(with: player),
//            SpellingState(with: player),
//            NinjitsuAnimatingState(with: player)
//        ])
        
        //        查询字体名字
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            print("Family: \(family) Font names: \(names)")
        //        }
        
    }
    
    //MARK: - GameLoop
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        //Camera
        cameraNode?.run(.move(to: CGPoint(x: player.position.x + 300, y: 0), duration: 0.1))
        joystick?.position.y = cameraNode!.position.y - size.height/4
        joystick?.position.x = cameraNode!.position.x - size.width/3

        //        jieyin_Cancel.position.y = cameraNode!.position.y - size.height/4
        //        jieyin_Cancel.position.x = cameraNode!.position.x + size.width/3
        jieyin_Group.position.y = cameraNode!.position.y
        jieyin_Group.position.x = cameraNode!.position.x
        jumpButton.position.y = cameraNode!.position.y - size.height/4 - 80
        jumpButton.position.x = cameraNode!.position.x + size.width/3
        dashButton.position.y = cameraNode!.position.y - size.height/4
        dashButton.position.x = cameraNode!.position.x + size.width/3 + 80
        ninjitsuButton.position.y = cameraNode!.position.y - size.height/4 + 80
        ninjitsuButton.position.x = cameraNode!.position.x + size.width/3
        attackButton.position.y = cameraNode!.position.y - size.height/4
        attackButton.position.x = cameraNode!.position.x + size.width/3 - 80
        
        //单位时间
//        let deltaTime = currentTime - previousTimeInterval
//        previousTimeInterval = currentTime
        
        //Player Movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = joystickKnob.position.x
        player.isMovingLeft = xPosition < 0
        player.isMovingRight = xPosition > 0
        
        player.physicsBody?.velocity.dx = xPosition * player.runSpeed
        
        
        player.stateMachine?.update(deltaTime: currentTime)

        
//        if !player.isDashing && player.vSpeed < 0 {
//            player.stateMachine!.enter(FallingState.self)
//        }
//        //跑动还是默认状态机
//        if !player.isInTheAir && !player.isDashing {
//            if floor(abs(xPosition)) != 0 {
//                player.stateMachine!.enter(RunningState.self)
//            }
//            else {
//                player.stateMachine!.enter(IdleState.self)
//            }
//        }
        
        player.xScale = approach(start: player.xScale, end: player.dxScale, shift: 0.05)
        player.yScale = approach(start: player.yScale, end: player.dyScale, shift: 0.05)


        
        //增加冲刺残影
//        if player.isDashing{
//            addDashShadow()
//        }
        

        
    }
}

//MARK: - LoadUI

extension GameScene {
    
    func loadUI(){
        
        //        if let tilemap = childNode(withName: "tilemap") as? SKTileMapNode {
        //            generateTileMapPhysicBody(map: tilemap)
        //            tilemap.removeFromParent()
        //        }
        
        //摄像机
        cameraNode = (childNode(withName: "cameraNode") as! SKCameraNode)
        
        
        joystick = SKSpriteNode(imageNamed: "joystick")
        joystickKnob = SKSpriteNode(imageNamed: "knob")
        joystick?.name = "joystick"
        joystickKnob?.name = "knob"
        joystick?.setScale(0.8)
        joystickKnob?.setScale(2)
        joystick?.alpha = 0.5
        joystick!.addChild(joystickKnob!)
        
        joystick?.position = CGPoint(x: -size.width/3 , y: -size.height/4)
        addChild(joystick!)
        
        
        
        //跳跃按钮
        jumpButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 - 80)
        jumpButton.setScale(2.5)
        jumpButton.zPosition = 10
        addChild(jumpButton)
        
        
        //冲刺按钮
        dashButton.position = CGPoint(x: size.width / 3 + 80 , y : -size.height/4 )
        dashButton.setScale(2.5)
        dashButton.zPosition = 1
        addChild(dashButton)
        
        //忍法按钮
        ninjitsuButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 + 80)
        ninjitsuButton.setScale(2.5)
        ninjitsuButton.zPosition = 1
        addChild(ninjitsuButton)
        
        //攻击按钮
        attackButton.position = CGPoint(x: size.width / 3 - 80 , y : -size.height/4)
        attackButton.setScale(2.5)
        attackButton.zPosition = 1
        addChild(attackButton)
        
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
        timeRemainingLabel = generateText(from: String(spellTimeRemaining), xPosition: 0, yPosition: 350)
        
        //初始化人物
        player = Avatar(characterName: "Sasuke", texture: SKTexture(imageNamed: "Sasuke/Idle/1"), scale: 2)
        player.position = CGPoint(x: -300, y: 300)
        
        addChild(player)
        
//        for i in 1...6 {
//            let shadow = SKTexture(imageNamed: "Sasuke/Dash/dash\(i)")
//            shadowPool.append(shadow)
//        }
        
        
    }
}



//MARK: - Touches
extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        //        guard let joystickKnob = joystickKnob else { return }
        //        guard let player = player else { return }
        for touch in touches {
            
            let location = touch.location(in: self)
            //如果点击摇杆
            isKnobMoving = joystick.contains(location)
            if isKnobMoving && !selectedNodes.values.contains(joystick){
                selectedNodes[touch] = joystick
            }
            
            //点击跳跃
            if jumpButton.contains(location) && player.jumpCount > 0{
                if !selectedNodes.values.contains(jumpButton) {
                    selectedNodes[touch] = jumpButton
                }
                jumpButton.isPressed = true
                player.jumpCount -= 1
                player.stateMachine!.enter(JumpingState.self)
                
            }
            if dashButton.contains(location) && dashTimeLeft == 0{
                if !selectedNodes.values.contains(dashButton) {
                    selectedNodes[touch] = dashButton
                }
                //点击冲刺
                dashButton.isPressed = true
                player.stateMachine!.enter(DashingState.self)
            }

        
            
            //            //默认状态
            //            if gameStateMachine.currentState is IdleState {
            //
            //                //如果点击忍法
            //                if ninjitsu_Button.contains(location){
            //                    gameStateMachine.enter(SpellingState.self)
            //
            //                }
            //                //结印中
            //            } else if gameStateMachine.currentState is SpellingState {
            //
            //
            //                //如果点击到印式,存下来
            //                for yinshi in twelveYin {
            //                    if yinshi.key!.contains(location) {
            //                        jieyin += yinshi.value
            //                    }
            //                }
            //
            //                //如果点到了取消按钮,返回默认状态
            //                if jieyin_Cancel.contains(location) {
            //                    gameStateMachine.enter(IdleState.self)
            //                }
            //
            //                //每次点击更新所节的印
            //                updateText(text: jieyin, node: &jieyinLabel!)
            //            }
            
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //解包
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        //如果没有动摇杆就不用做什么了
//        if !isKnobMoving { return }
        
        //计算距离
        for touch in touches {
            if let node = selectedNodes[touch] {
            if node.name == "jump"{
                
            } else if node.name == "dash" {
                
            } else if node.name == "joystick"{
                let position = touch.location(in: joystick) //joystick里面的坐标系
                let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
                let angle = atan2(position.y, position.x)
                
                if knobRadius > length {
                    joystickKnob.position = position
                } else {
                    joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
                }
            
            

                }
            }

        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //注意当scene在移动时location在不停变化
        //        guard let joystick = joystick else { return }
        for touch in touches {
            
            if selectedNodes[touch] != nil {
                if (selectedNodes[touch] == jumpButton){
                    jumpButton.isPressed = false
                }
                if (selectedNodes[touch] == dashButton){
                    dashButton.isPressed = false
                }
                if (selectedNodes[touch] == joystick){
                    resetKnobPosition()
                    isKnobMoving = false
                }
                selectedNodes[touch] = nil
            }
//            let location = touch.location(in: self)
//            let preventContactAreaXPostion = dashButton.position.x - 200
            
            //按钮旁边的位置防止误触
//            if location.x < preventContactAreaXPostion {
//                resetKnobPosition()
//                isKnobMoving = false
//            } else { isKnobMoving = true}
//
//            if jumpButton.isPressed {
//                jumpButton.isPressed = false
//            }
//            if dashButton.isPressed {
//                dashButton.isPressed = false
//            }
            
        }
        
        
    }
}
    
    


//MARK: - Action
extension GameScene {
    
    
    //遍历tilemap
//    func generateTileMapPhysicBody(map: SKTileMapNode){
//        let tileSize = map.tileSize
//        let halfWidth = CGFloat(map.numberOfColumns) / 2 * tileSize.width
//        let halfHeight = CGFloat(map.numberOfRows) / 2 * tileSize.height
//
//        for col in 0..<map.numberOfColumns{
//            for row in 0..<map.numberOfRows{
//                if let tileDefinition = map.tileDefinition(atColumn: col, row: row) {
//                    let textures = tileDefinition.textures
//                    let tileTexture = textures.first
//                    let xPosition = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
//                    let yPosition = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
//
//                    //每个模块建立刚体
//                    let tileCell = SKSpriteNode(texture: tileTexture)
//                    tileCell.position = CGPoint(x: xPosition, y: yPosition)
//                    tileCell.zPosition = -1
//                    tileCell.physicsBody = SKPhysicsBody(rectangleOf: tileTexture!.size())
//                    tileCell.setScale(2)
//                    tileCell.physicsBody?.isDynamic = false
//                    tileCell.physicsBody?.affectedByGravity = false
//                    tileCell.physicsBody?.linearDamping = 60
//                    tileCell.physicsBody?.friction = 1
//
//                    tileCell.physicsBody?.categoryBitMask = CollisionType.ground.mask
//                    tileCell.physicsBody?.collisionBitMask = CollisionType.player.mask
//                    tileCell.physicsBody?.contactTestBitMask = CollisionType.player.mask
//
//                    addChild(tileCell)
//                }
//            }
//        }
//    }
    
    
    
    //重置摇杆位置
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        isKnobMoving = false
    }
    
    
    //dash动画
    func addDashShadow(){
        let shadownode = SKSpriteNode(texture: shadowPool[shadowTextureIndex])
        shadownode.position = self.player.position
        shadownode.xScale = self.player.xScale
        shadownode.yScale = self.player.yScale
        shadownode.zPosition = self.player.zPosition
        addChild(shadownode)
        shadownode.run(.sequence([
            .fadeOut(withDuration: player.shadowFadeOut),
            .run {
                shadownode.removeFromParent()
            }
        ]))
        if shadowTextureIndex < 5 {
            shadowTextureIndex += 1
        } else {
            shadowTextureIndex = 0
        }

    }
    
    
    
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
    
    
    
    func addperformNinpo(from node: inout SKSpriteNode){
        
        //新动画
        var textureArray :[SKTexture] = []
        //        for i in 1...12{
        //            textureArray.append(SKTexture.init(imageNamed: "Sasuke/Huoqiuninpo/\(i)"))
        //        }
        for i in 1...9{
            textureArray.append(SKTexture.init(imageNamed: "Sasuke/Huoqiurepeat/\(i)"))
        }
        
        
        let position = node.position
        let xScale = node.xScale
        let yScale = node.yScale
        
        node.removeAllChildren()
        
        node.texture = textureArray[0]
        //        node.size = size
        node.position = position
        //        newnode.zPosition = zPosition
        node.xScale = xScale
        node.yScale = yScale
        addChild(node)
        
        node.run(.repeatForever(.animate(with: textureArray, timePerFrame: 0.15)))
        addfire()
        
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
                .wait(forDuration: 3),
                .fadeOut(withDuration: 0.5),
                .removeFromParent()
            ]))
            
            
            
        }
    }
    

    func approach(start: CGFloat, end:CGFloat  , shift: CGFloat) -> CGFloat {
        if (start < end) {
            return min(start + shift , end)
        } else {
            return max(start - shift , end)
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
    //剪切图片
    //        var texture = Array<SKTexture>()
    //        var texture1 = Array<SKTexture>()
    //        let gaara = UIImage(named:"Gaara")!
    //
    //        let gaaracropped1 = gaara.cgImage?.cropping(to: CGRect(x: 439, y: 512-213, width: 36, height: 76))
    //        let gaaracropped2 = gaara.cgImage?.cropping(to: CGRect(x: 380, y: 512-(275+76), width: 36, height: 76))
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

//MARK: - Collisions
extension GameScene: SKPhysicsContactDelegate  {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask , second: contact.bodyB.categoryBitMask))
        if collision.matches(.player, .ground){
            player.isInTheAir = false
            player.jumpCount = 2
        }
    }
    
}

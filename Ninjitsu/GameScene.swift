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
    
    //stats
    var twelveYin :[SKNode? : String] = [:]
    var jieyin = ""
    var spellTimeRemaining : TimeInterval = 10 //结印倒计时
    var knobRadius : CGFloat = 100 //摇杆半径
    var jumpCount : Int = 2 //跳跃次数
    var jumpForceY : Double = 125 //跳跃力量
    var difference : (CGFloat, CGFloat)?
    var previousTimeInterval : TimeInterval = 0
    let dashCoolDown : TimeInterval = 3
    var dashTimeLeft : TimeInterval = 0
    var ySpeed : CGFloat = 0 //垂直速度
    
    //Bool
    var isKnobMoving = false //是否在控制摇杆
    
    //Touches
    var selectedNodes: [UITouch : CGPoint] = [ : ]
    
    //GameState
    var playerGSMachine : GKStateMachine!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        
        loadUI()
        
        playerGSMachine = GKStateMachine(states: [
            IdleState(with: player),
            RunningState(with: player),
            JumpingState(with: player),
            FallingState(with: player),
            DashingState(with: player),
            SpellingState(with: player),
            NinjitsuAnimatingState(with: player)
        ])
        
        //        查询字体名字
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            print("Family: \(family) Font names: \(names)")
        //        }
        
    }
    
    //MARK: - GameLoop
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        //Camera
        cameraNode?.position.x = player.position.x + 300
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
        
        
        //垂直速度
        ySpeed = player.physicsBody!.velocity.dy
        
        //判断何时在空中
        player.isInTheAir = ySpeed != 0
        
        //单位时间
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        //Player Movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        
        
        if player.isInTheAir && ySpeed < 0 {
            playerGSMachine.enter(FallingState.self)
        }
        
        //跑动还是默认状态机
        if !player.isInTheAir && !player.isDashing {
            if floor(abs(xPosition)) != 0 {
                playerGSMachine.enter(RunningState.self)
            }
            else {
                playerGSMachine.enter(IdleState.self)
            }
        }
        
        let displacement = CGVector(dx: deltaTime * xPosition * Double(player.runSpeed), dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceAction: SKAction!
        let isMovingRight = xPosition > 0
        let isMovingLeft = xPosition < 0
        if isMovingLeft && player.isFacingRight{
            player.isFacingRight = false
            let turnArround = SKAction.scaleX(to: -abs(player!.xScale), duration: 0)
            faceAction = .sequence([move, turnArround])
            
        } else if isMovingRight && !player.isFacingRight {
            player.isFacingRight = true
            let turnArround = SKAction.scaleX(to: abs(player!.xScale), duration: 0)
            faceAction = .sequence([move, turnArround])
            
        } else {
            faceAction = move
        }
        player?.run(faceAction)
        
        
        //增加冲刺残影
        if player.isDashing{
            addDashShadow()
        }
        
        
        
        
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
        joystick?.setScale(0.8)
        joystickKnob?.setScale(2)
        joystick?.alpha = 0.5
        joystick!.addChild(joystickKnob!)
        
        joystick?.position = CGPoint(x: -size.width/3 , y: -size.height/4)
        addChild(joystick!)
        print(joystick!.position)
        
        
        //跳跃按钮
        jumpButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 - 80)
        jumpButton.setScale(2.5)
        jumpButton.zPosition = 10
        print(jumpButton.position)
        addChild(jumpButton)
        
        
        //冲刺按钮
        dashButton.position = CGPoint(x: size.width / 3 + 80 , y : -size.height/4 )
        dashButton.setScale(2.5)
        dashButton.zPosition = 1
        print(jumpButton.position)
        addChild(dashButton)
        
        //忍法按钮
        ninjitsuButton.position = CGPoint(x: size.width / 3 , y : -size.height/4 + 80)
        ninjitsuButton.setScale(2.5)
        ninjitsuButton.zPosition = 1
        print(jumpButton.position)
        addChild(ninjitsuButton)
        
        //攻击按钮
        attackButton.position = CGPoint(x: size.width / 3 - 80 , y : -size.height/4)
        attackButton.setScale(2.5)
        attackButton.zPosition = 1
        print(jumpButton.position)
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
            
            //点击跳跃
            if jumpButton.contains(location) && jumpCount > 0{
                jumpButton.isPressed = true
                jumpCount -= 1
                playerGSMachine.enter(JumpingState.self)
                player.run(.applyForce(CGVector(dx: 0, dy: jumpForceY), duration: 0.1))
                player.isInTheAir = true
                
            }
            
            //点击冲刺
            if dashButton.contains(location) && dashTimeLeft == 0 {
                player.isDashing = true
                dashButton.isPressed = true
                playerGSMachine.enter(DashingState.self)
                
                //在地上以及下降时的冲刺力度
                let groundDash = SKAction.move(by: CGVector(dx: (player.isFacingRight ? player.dashX : -player.dashX), dy: 0), duration: 0.15)
                let liftDash = SKAction.move(by: CGVector(dx: (player.isFacingRight ? player.dashX : -player.dashX), dy: player.dashY), duration: 0.15)
                
                //施力与状态变更
                player!.run(.sequence([
                    player.isInTheAir && player.physicsBody!.velocity.dy > 0 ? liftDash : groundDash,
                    .run {
                        self.player.isDashing = false
                    }
                ]))
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
        if !isKnobMoving { return }
        
        //计算距离
        for touch in touches {
            //            let location = touch.location(in: self) // scene的坐标系
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //注意当scene在移动时location在不停变化
        //        guard let joystick = joystick else { return }
        for touch in touches {
            
            let location = touch.location(in: self)
            let preventContactAreaXPostion = dashButton.position.x - 200
            
            //按钮旁边的位置防止误触
            if location.x < preventContactAreaXPostion {
                resetKnobPosition()
                isKnobMoving = false
            } else { isKnobMoving = true}
            
            if jumpButton.isPressed {
                jumpButton.isPressed = false
            }
            if dashButton.isPressed {
                dashButton.isPressed = false
            }
            
        }
        
        
        
    }
    
    
}

//MARK: - Action
extension GameScene {
    
    func generateTileMapPhysicBody(map: SKTileMapNode){
        let tileSize = map.tileSize
        let halfWidth = CGFloat(map.numberOfColumns) / 2 * tileSize.width
        let halfHeight = CGFloat(map.numberOfRows) / 2 * tileSize.height
        
        for col in 0..<map.numberOfColumns{
            for row in 0..<map.numberOfRows{
                if let tileDefinition = map.tileDefinition(atColumn: col, row: row) {
                    let textures = tileDefinition.textures
                    let tileTexture = textures.first
                    let xPosition = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let yPosition = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    //每个模块建立刚体
                    let tileCell = SKSpriteNode(texture: tileTexture)
                    tileCell.position = CGPoint(x: xPosition, y: yPosition)
                    tileCell.zPosition = -1
                    tileCell.physicsBody = SKPhysicsBody(rectangleOf: tileTexture!.size())
                    tileCell.setScale(2)
                    tileCell.physicsBody?.isDynamic = false
                    tileCell.physicsBody?.affectedByGravity = false
                    tileCell.physicsBody?.linearDamping = 60
                    tileCell.physicsBody?.friction = 1
                    
                    tileCell.physicsBody?.categoryBitMask = CollisionType.ground.mask
                    tileCell.physicsBody?.collisionBitMask = CollisionType.player.mask
                    tileCell.physicsBody?.contactTestBitMask = CollisionType.player.mask
                    
                    addChild(tileCell)
                }
            }
        }
    }
    
    
    
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
        let shadownode = SKSpriteNode(texture: self.player.texture)
        shadownode.position = self.player.position
        shadownode.xScale = self.player.xScale
        shadownode.yScale = self.player.yScale
        shadownode.zPosition = self.player.zPosition
        addChild(shadownode)
        shadownode.run(.sequence([
            .fadeOut(withDuration: 0.1),
            .run {
                shadownode.removeFromParent()
            }
        ]))
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

//MARK: - Collisions
extension GameScene: SKPhysicsContactDelegate  {
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask , second: contact.bodyB.categoryBitMask))
        if collision.matches(.player, .ground){
            //            player.texture = SKTexture(imageNamed: "Sasuke/onground")
            playerGSMachine.enter(IdleState.self)
            jumpCount = 2
        }
    }
    
}

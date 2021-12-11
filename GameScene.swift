//
//  GameScene.swift
//  customGameFinalVersion
//
//  Created by Aleyna  Ceylan on 11/15/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

let player = SKSpriteNode(imageNamed: "player-rocket")
let motionManager = CMMotionManager()

class GameScene: SKScene, SKPhysicsContactDelegate {
    var background = SKSpriteNode()
    var particles = SKEmitterNode()
    var touchingPlayer = false
    var timer: Timer?
    var scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    
    var scoreVal = 0{
        didSet{
            scoreLabel.text = "SCORE: \(scoreVal)"
        }
    }

    override func sceneDidLoad() {
        
        scoreLabel.position.y = 720
        scoreLabel.zPosition = 2
        addChild(scoreLabel)

        // Initialize the scoreVal.
        scoreVal = 0
        
        // For the background sprite, the spacebg2.jpeg image is given as texture.
        let texture = SKTexture(imageNamed: "spacebg2")
        background = SKSpriteNode(texture: texture)
        // For the sprite to center the screen, its coordinates on the 2D plane were determined as 0 using the position method.
        background.position = CGPoint(x: 0, y: 0)
        // The edge length values were determined so that the image could cover the entire screen.
        background.size = CGSize(width: 2360, height: 1640)
        // The depth of the background on the game screen is set to 1.
        background.zPosition = -1
        self.addChild(background)
        
        if let particles = SKEmitterNode(fileNamed: "FlyningEffect") {
            // By synchronizing the Particle and Background positions, I wanted to ensure that these two objects were aligned on the screen.
            particles.position.x = 512
            particles.zPosition = 0
            addChild(particles)
            // Player Features.
            player.position.x = -400
            player.zPosition = 1
            // Added player sprite as a child node.
            addChild(player)
            
            motionManager.startAccelerometerUpdates()
            
            // Timer
            timer = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(createEnemyAstreoid), userInfo: nil, repeats: true)
            
            timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemySpaceJunk), userInfo: nil, repeats: true)

//            timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemyShip), userInfo: nil, repeats: true)
            
            // Collision Detection
            player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
            player.physicsBody?.categoryBitMask = 1
            player.physicsBody?.affectedByGravity = false
            
            physicsWorld.contactDelegate = self
            
            
            
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if tappedNodes.contains(player){
            touchingPlayer = true
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchingPlayer else {return}
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingPlayer = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData{
            let changeInX = CGFloat(accelerometerData.acceleration.y) * 100
            let changeInY = CGFloat(accelerometerData.acceleration.x) * 100
            
            player.position.x -= changeInX
            player.position.y -= changeInY
            
            if abs(changeInX) + abs(changeInY) <= 2{
                scoreVal += 1
            }
            
            scoreLabel.text = "SCORE: \(scoreVal)"
        }
    }
    
    @objc func createEnemyAstreoid(){
        let randomDistribution = GKRandomDistribution(lowestValue: -680, highestValue: 680)
        let enemySprite = SKSpriteNode(imageNamed: "asteroid")
        
        enemySprite.position = CGPoint(x: Int(self.frame.maxX), y: randomDistribution.nextInt())
        enemySprite.zPosition = 1
        addChild(enemySprite)
        
        enemySprite.physicsBody = SKPhysicsBody(texture: enemySprite.texture!, size: enemySprite.size)
        enemySprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemySprite.physicsBody?.affectedByGravity = false
        enemySprite.physicsBody?.linearDamping = 0
        
        enemySprite.physicsBody?.contactTestBitMask = 1
        enemySprite.physicsBody?.categoryBitMask = 0
        
    }
    
    @objc func createEnemySpaceJunk(){
        let randomDistribution = GKRandomDistribution(lowestValue: -300, highestValue: 300)
        let enemySprite = SKSpriteNode(imageNamed: "space-junk")

        enemySprite.position = CGPoint(x: 1000, y:
        randomDistribution.nextInt())
        enemySprite.zPosition = 1
        addChild(enemySprite)

        enemySprite.physicsBody = SKPhysicsBody(texture: enemySprite.texture!, size: enemySprite.size)
        enemySprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemySprite.physicsBody?.affectedByGravity = false
        enemySprite.physicsBody?.linearDamping = 0

        enemySprite.physicsBody?.contactTestBitMask = 1
        enemySprite.physicsBody?.categoryBitMask = 0

    }
    
//    @objc func createEnemyShip(){
//        let randomDistribution = GKRandomDistribution(lowestValue: -820, highestValue: 820)
//        let enemySprite = SKSpriteNode(imageNamed: "space-junk")
//
//        enemySprite.position = CGPoint(x: 1000, y: randomDistribution.nextInt())
//        enemySprite.zPosition = 1
//        addChild(enemySprite)
//
//        enemySprite.physicsBody = SKPhysicsBody(texture: enemySprite.texture!, size: enemySprite.size)
//        enemySprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
//        enemySprite.physicsBody?.affectedByGravity = false
//        enemySprite.physicsBody?.linearDamping = 0
//
//        enemySprite.physicsBody?.contactTestBitMask = 1
//        enemySprite.physicsBody?.categoryBitMask = 0
//
//    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA == player{
            playerHitted(nodeB)
        } else{
            playerHitted(nodeA)
        }
        func playerHitted(_ node: SKNode){
//            let GameOverScene = SKSpriteNode
            player.removeFromParent()
        }
    }
}


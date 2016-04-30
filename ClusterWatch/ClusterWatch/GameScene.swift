import SpriteKit


struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Spike:  UInt32 = 0x1 << 3
    static let Missile: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var runner = SKSpriteNode(imageNamed: "runner")
    let floor = SKSpriteNode(imageNamed: "floor")
    let dodgebutton = SKSpriteNode(imageNamed: "dodgebutton")
    let missilebutton = SKSpriteNode(imageNamed: "missilebutton")
    let missile = SKSpriteNode(imageNamed: "missile")
    var gameReady = false
    var score = 0
    var numJumps = 0
    var now : NSDate?
    var nextTime : NSDate?
    let backgroundVelocity : CGFloat = 5
    let scorelabel = SKLabelNode(fontNamed: "PerfectDarkBRK")



    func gameSetup(){
        self.backgroundColor = SKColor.whiteColor()
        
        dodgebutton.size     = CGSize(width: 100, height: 100)
        dodgebutton.position = CGPoint(x: self.frame.width - 200, y: floor.frame.height / 2);
        dodgebutton.zPosition = 5
        dodgebutton.name = "dodgebutton"
        
        missilebutton.size     = CGSize(width: 100, height: 100)
        missilebutton.position = CGPoint(x: self.frame.width - 320, y: floor.frame.height / 2);
        missilebutton.zPosition = 5
        missilebutton.name = "missilebutton"
        
        floor.xScale = 2
        floor.position = CGPoint(x: 0, y: floor.frame.height / 2);
        
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        floor.physicsBody?.collisionBitMask = PhysicsCategory.Player
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.dynamic = false
        
        runner.size = CGSize(width: 100, height: 100)
        runner.position = CGPoint(x: self.frame.size.width / 10 , y: floor.frame.height);
        runner.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "runner"), size: CGSize(width: 100, height: 100))
        runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
        runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
        runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
        runner.physicsBody?.affectedByGravity = true
        runner.physicsBody?.dynamic = true
        
        let message = "Score: \(score)"
        scorelabel.text = message
        scorelabel.fontSize = 40
        scorelabel.fontColor = SKColor.blackColor()
        scorelabel.position = CGPoint(x: self.frame.width/10, y: self.frame.height * 0.9)
        self.addChild(scorelabel)
        

        self.addChild(dodgebutton)
        self.addChild(missilebutton)

        self.addChild(runner)
        self.addChild(floor)
        
    }
    

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.removeAllChildren()
        self.physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity = CGVectorMake(0, -15)
        gameSetup()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            if gameReady == false {
                gameReady = true
            }
            else {
            
            let location = (touch).locationInNode(self)
//            print(touch.tapCount)
            
            if let name = self.nodeAtPoint(location).name {
                if( name == "dodgebutton"){
                    runner.texture = SKTexture(imageNamed: "dodge")
                    runner.size = CGSize(width: 100, height: 100)
                    runner.position.x = self.frame.width / 10
                    runner.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "dodge"), size: CGSize(width: 90, height: 75))
                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.affectedByGravity = true
                    runner.physicsBody?.dynamic = true
                }
                else if( name == "missilebutton"){
                    missile.removeFromParent()
                    missile.size = CGSize(width: 100, height: 32)
                    missile.position = CGPoint(x: runner.position.x + runner.frame.width/2, y: runner.position.y - runner.frame.height/16)
                    missile.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "missile"), size: CGSize(width: 100, height: 32))
                    missile.physicsBody?.categoryBitMask = PhysicsCategory.Missile
                    missile.physicsBody?.collisionBitMask = PhysicsCategory.Ground
                    missile.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
                    missile.physicsBody?.affectedByGravity = false
                    missile.physicsBody?.dynamic = true
                    missile.physicsBody?.velocity = CGVectorMake(800, missile.position.y)
                    self.addChild(missile)
                }
            } else if touch.tapCount <= 2 {
//                print(numJumps)
                if numJumps == 1 {
                    let rotation = SKAction.rotateByAngle( CGFloat(2 * -M_PI), duration: 0.75)
                    runner.runAction(rotation)
                }
                if numJumps < 2
                {
                    runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 400)
                    numJumps = numJumps + 1
                }
                
                
            }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = (touch).locationInNode(self)
            //            print(touch.tapCount)
            
            if let name = self.nodeAtPoint(location).name {
                if( name == "dodgebutton"){
                    runner.texture = SKTexture(imageNamed: "runner")
                    runner.size = CGSize(width: 100, height: 100)
                    runner.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "runner"), size: CGSize(width: 100, height: 100))
                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.affectedByGravity = true
                    runner.physicsBody?.dynamic = true
                }
                
            }
//            else if touch.tapCount <= 2 {
//                
//                if numJumps < 3
//                {
//                    runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 200)
//                    numJumps = numJumps + 1
//                }
//            }
        }
    }
   
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Spike {
//            print("Hit player")

            let duration = 0.25
            let finalHeightScale:CGFloat = 0.0
            let scaleHeightAction = SKAction.scaleYTo(finalHeightScale, duration: duration)
            
            gameReady = false
            runner.runAction(scaleHeightAction, completion: { () -> Void in })
            self.runAction(SKAction.fadeInWithDuration(1.0), completion: {
                self.removeAllChildren()
                let transition:SKTransition = SKTransition.fadeWithDuration(1)
                let gameOverScene = GameOverScene(size: self.size, score: self.score)
                self.view?.presentScene(gameOverScene, transition: transition)
            })
        }
        if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Ground) || (firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Player)
        {
            print("floored")
            numJumps = 0
        }
    }
    
    func checkIfObjReachesEnd(){
        for child in self.children {
            if(child.position.x <= -1){
                self.removeChildrenInArray([child])
//                print("+1")
                score = score + 1
                scorelabel.text = "Score: " + String(score)
            }
            
            
        }
    }
    
    func generateSmallSpike(){
        let spike = SKSpriteNode(imageNamed: "spike")

        spike.size = CGSize(width: 70, height: 70)
        let rnd = arc4random_uniform(2)
        
        if rnd == 1{
            spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 30)
        }
        else {
            spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 386)
        }
        spike.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spike"), size: CGSize(width: 70, height: 70))
        spike.physicsBody?.categoryBitMask = PhysicsCategory.Spike
        spike.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        spike.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        spike.physicsBody?.affectedByGravity = true
        spike.physicsBody?.dynamic = true
        spike.physicsBody?.velocity = CGVectorMake(-1000, spike.position.y)
        self.addChild(spike)
    }
    
    func generateLargeSpike(){
        let spike = SKSpriteNode(imageNamed: "spike")

        spike.size = CGSize(width: 150, height: 175)
        spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 80);
        spike.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spike"), size: CGSize(width: 150, height: 175))
        spike.physicsBody?.categoryBitMask = PhysicsCategory.Spike
        spike.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        spike.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        spike.physicsBody?.affectedByGravity = true
        spike.physicsBody?.dynamic = true
        spike.physicsBody?.velocity = CGVectorMake(-1000, spike.position.y)
        self.addChild(spike)
    }
    
    func generateBullet(){
        let obj = SKSpriteNode(imageNamed: "obj")

        obj.size = CGSize(width: 150, height: 200)
        obj.position = CGPoint(x: self.frame.size.width, y: 250);
        obj.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "obj"), size: CGSize(width: 150, height: 200))
        obj.physicsBody?.categoryBitMask = PhysicsCategory.Spike
        obj.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        obj.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        obj.physicsBody?.affectedByGravity = false
        obj.physicsBody?.dynamic = false
        obj.physicsBody?.velocity = CGVectorMake(-1000, obj.position.y)
        
        let action = SKAction.moveTo(CGPoint(x:-300, y: 250), duration: 2)
        obj.runAction(action)
        
        self.addChild(obj)
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        
        /* Called before each frame is rendered */
        if gameReady {
            if runner.position.x >= self.frame.width { runner.position.x = 0 }
            if runner.position.y >= self.frame.height - 140 { runner.position.y = self.frame.height - 140 }
        
            
            now = NSDate()
            if (now?.timeIntervalSince1970 > nextTime?.timeIntervalSince1970){
                let rnd = arc4random_uniform(5) // 0-4
                nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(2.0))
                
                
                
                if score <= 9 {
                    print("Level 1 - "  + String(rnd))
                        generateSmallSpike()
                } else if score <= 19 {
                    print("Level 2 - " + String(rnd))
                    if rnd <= 2 {
                        generateSmallSpike()
                    } else {
                        generateLargeSpike()
                    }
                } else if score <= 29 {
                    print("Level 3 - " + String(rnd))
                    if rnd <= 1 {
                        generateSmallSpike()
                    } else if rnd == 2 || rnd == 3{
                        generateLargeSpike()
                    } else {
                        generateBullet()
                    }
                } else {
                    print("Level 4+ - " + String(rnd))
                    if rnd == 0 {
                        generateSmallSpike()
                    } else if rnd == 1 || rnd == 2{
                        generateLargeSpike()
                    } else {
                        generateBullet()
                    }
                }
                
                
                
                checkIfObjReachesEnd()
            }
        }
        
       
        
        
        
    }
}

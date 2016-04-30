import SpriteKit


struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Spike:  UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let runner = SKSpriteNode(imageNamed: "runner")
    let floor = SKSpriteNode(imageNamed: "floor")
    let dodgebutton = SKSpriteNode(imageNamed: "dodgebutton")
    
    var now : NSDate?
    var nextTime : NSDate?

    func gameSetup(){
        self.backgroundColor = SKColor.whiteColor()
        
        dodgebutton.size     = CGSize(width: 100, height: 100)
        dodgebutton.position = CGPoint(x: self.frame.width - 200, y: floor.frame.height / 2);
        dodgebutton.zPosition = 5
        dodgebutton.name = "dodgebutton"
        
        floor.xScale = 2
        floor.position = CGPoint(x: 0, y: floor.frame.height / 2);
        
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        floor.physicsBody?.collisionBitMask = PhysicsCategory.Player
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.dynamic = false
        
        runner.size = CGSize(width: 100, height: 100)
        runner.position = CGPoint(x: self.frame.size.width / 10 , y: floor.frame.height + 140);
        
        runner.physicsBody = SKPhysicsBody(rectangleOfSize: runner.size)
        runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
        runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
        runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
        runner.physicsBody?.affectedByGravity = true
        runner.physicsBody?.dynamic = true
        

        
        self.addChild(dodgebutton)
        self.addChild(runner)
        self.addChild(floor)
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity = CGVectorMake(0, -15)
        gameSetup()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = (touch).locationInNode(self)
//            print(touch.tapCount)
            
            if let name = self.nodeAtPoint(location).name {
                if( name == "dodgebutton"){
                    print("dodge")
                    runner.size = CGSize(width: 50, height: 50)
                    runner.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50, height: 50))
                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.affectedByGravity = true
                    runner.physicsBody?.dynamic = true
                }
            } else if touch.tapCount <= 2 {
                runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 400)
            }
            
            
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = (touch).locationInNode(self)
            //            print(touch.tapCount)
            
            if let name = self.nodeAtPoint(location).name {
                if( name == "dodgebutton"){
                    print("dodge")
                    runner.size = CGSize(width: 90, height: 90)
                    runner.physicsBody = SKPhysicsBody(rectangleOfSize: runner.size)
                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
                    runner.physicsBody?.affectedByGravity = true
                    runner.physicsBody?.dynamic = true
                }
            } else if touch.tapCount <= 2 {
                runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 200)
            }
            
        }
    }
   
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Spike {
            print("Hit player")

            let duration = 0.25
            let finalHeightScale:CGFloat = 0.0
            let scaleHeightAction = SKAction.scaleYTo(finalHeightScale, duration: duration)
            
            runner.runAction(scaleHeightAction, completion: { () -> Void in })
            self.runAction(SKAction.fadeInWithDuration(1.0), completion: {
                self.removeAllChildren()
                let transition:SKTransition = SKTransition.fadeWithDuration(1)
                let gameOverScene = GameOverScene(size: self.size, score: 1)
                self.view?.presentScene(gameOverScene, transition: transition)
            })
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if runner.position.x >= self.frame.width { runner.position.x = 0 }
        if runner.position.y >= self.frame.height - 140 { runner.position.y = self.frame.height - 140 }
        
        now = NSDate()
        if (now?.timeIntervalSince1970 > nextTime?.timeIntervalSince1970){
            let rnd = arc4random_uniform(10)
            
            nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(2.0))
            let spike = SKSpriteNode(imageNamed: "spike")
            
            if (rnd < 8)
            {
                spike.size = CGSize(width: 70, height: 70)
                
                spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 30);
                
                let offsetX: CGFloat = spike.frame.size.width * spike.anchorPoint.x
                let offsetY: CGFloat = spike.frame.size.height * spike.anchorPoint.y
                
                let path: CGMutablePathRef = CGPathCreateMutable()
                
                
                CGPathMoveToPoint(path, nil, 28 - offsetX, 70 - offsetY);
                CGPathAddLineToPoint(path, nil, 6 - offsetX, 13 - offsetY);
                CGPathAddLineToPoint(path, nil, 0 - offsetX, 10 - offsetY);
                CGPathAddLineToPoint(path, nil, 0 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, nil, 63 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, nil, 63 - offsetX, 1 - offsetY);
                CGPathAddLineToPoint(path, nil, 58 - offsetX, 15 - offsetY);
                CGPathAddLineToPoint(path, nil, 52 - offsetX, 16 - offsetY);
                CGPathAddLineToPoint(path, nil, 29 - offsetX, 70 - offsetY);
                
                CGPathCloseSubpath(path);
                
                spike.physicsBody = SKPhysicsBody(polygonFromPath: path)
                
            }
            else
            {
                spike.size = CGSize(width: 150, height: 175)
                
                spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 80);
                
                let offsetX: CGFloat = spike.frame.size.width * spike.anchorPoint.x
                let offsetY: CGFloat = spike.frame.size.height * spike.anchorPoint.y
                
                let path: CGMutablePathRef = CGPathCreateMutable()
                
                
                CGPathMoveToPoint(path, nil, 68 - offsetX, 175 - offsetY);
                CGPathAddLineToPoint(path, nil, 20 - offsetX, 26 - offsetY);
                CGPathAddLineToPoint(path, nil, 0 - offsetX, 25 - offsetY);
                CGPathAddLineToPoint(path, nil, 0 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, nil, 150 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, nil, 150 - offsetX, 0 - offsetY);
                CGPathAddLineToPoint(path, nil, 140 - offsetX, 25 - offsetY);
                CGPathAddLineToPoint(path, nil, 108 - offsetX, 25 - offsetY);
                CGPathAddLineToPoint(path, nil, 68 - offsetX, 175 - offsetY);
                
                CGPathCloseSubpath(path);
                
                spike.physicsBody = SKPhysicsBody(polygonFromPath: path)
            
            }
            
            spike.physicsBody?.categoryBitMask = PhysicsCategory.Spike
            spike.physicsBody?.collisionBitMask = PhysicsCategory.Ground
            spike.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
            spike.physicsBody?.affectedByGravity = true
            spike.physicsBody?.dynamic = true
            spike.physicsBody?.velocity = CGVectorMake(-1000, spike.position.y)
            
            self.addChild(spike)
        }
        
        
        
    }
}

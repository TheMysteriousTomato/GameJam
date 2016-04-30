import SpriteKit


struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Spike:  UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let runner = SKSpriteNode(imageNamed: "runner")
    let floor = SKSpriteNode(imageNamed: "floor")
    var now : NSDate?
    var nextTime : NSDate?

    func gameSetup(){
        self.backgroundColor = SKColor.whiteColor()
        
        floor.xScale = 2
        floor.position = CGPoint(x: 0, y: floor.frame.height / 2);
        
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        floor.physicsBody?.collisionBitMask = PhysicsCategory.Player
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.dynamic = false
        
        runner.size = CGSize(width: 175, height: 175)
        runner.position = CGPoint(x: self.frame.size.width / 10, y: floor.frame.height + 150);
        
        runner.physicsBody = SKPhysicsBody(rectangleOfSize: runner.size)
        runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
        runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
        runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike
        runner.physicsBody?.affectedByGravity = true
        runner.physicsBody?.dynamic = true
        

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
            print(touch.tapCount)
            let _ = touch.locationInNode(self)
            if touch.tapCount <= 2 {
                runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 600)
            }
        }
    }
   
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Spike {
            print("Hit player")
            self.runAction(SKAction.fadeInWithDuration(0.5), completion: {
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
            nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(2.0))
            let spike = SKSpriteNode(imageNamed: "spike")
            spike.size = CGSize(width: 150, height: 150)
            spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 50);
            spike.physicsBody = SKPhysicsBody(rectangleOfSize: spike.size)
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

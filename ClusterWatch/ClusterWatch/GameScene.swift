import SpriteKit


struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Spike:  UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    let runner = SKSpriteNode(imageNamed: "runner")

    func gameSetup(){
        let floor = SKSpriteNode(imageNamed: "floor")
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
        runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        runner.physicsBody?.affectedByGravity = true
        runner.physicsBody?.dynamic = true
        
        let spike = SKSpriteNode(imageNamed: "spike")
        spike.size = CGSize(width: 150, height: 150)
        spike.position = CGPoint(x: self.frame.size.width, y: floor.frame.height + 50);

        let action = SKAction.moveTo(CGPoint(x: 0, y: floor.frame.height+50), duration: 2)
        spike.physicsBody = SKPhysicsBody(rectangleOfSize: runner.size)
        spike.physicsBody?.categoryBitMask = PhysicsCategory.Spike
        spike.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Player
        spike.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Player
        spike.physicsBody?.affectedByGravity = true
        spike.physicsBody?.affectedByGravity = true
        
        spike.runAction(action)
        
        self.addChild(spike)
        self.addChild(runner)
        self.addChild(floor)
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        gameSetup()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let _ = touch.locationInNode(self)
            runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 600)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if runner.position.x >= self.frame.width
        {
            runner.position.x = 0
        }
        if runner.position.y >= self.frame.height - 140
        {
            runner.position.y = self.frame.height - 140
        }
    }
}

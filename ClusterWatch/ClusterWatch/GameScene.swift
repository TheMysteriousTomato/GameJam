import SpriteKit


struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
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
            runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 420)
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

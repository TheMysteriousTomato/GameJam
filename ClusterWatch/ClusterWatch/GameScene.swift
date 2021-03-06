import SpriteKit
import CoreData


struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Spike:  UInt32 = 0x1 << 3
    static let Missile: UInt32 = 0x1 << 4
    static let Wall: UInt32 = 0x1 << 5
    static let Net: UInt32 = 0x1 << 6
    static let Fireblast: UInt32 = 0x1 << 6
    static let Cluster: UInt32 = 0x1 << 7

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var runner = SKSpriteNode()
    let floor = SKSpriteNode(imageNamed: "floor")
    let dodgebutton = SKSpriteNode(imageNamed: "dodgebutton")
    let missilebutton = SKSpriteNode(imageNamed: "missilebutton")
    let fireballbutton = SKSpriteNode(imageNamed: "fireballbutton")
    let jumpbutton = SKSpriteNode(imageNamed: "jumpbutton")
    let missile = SKSpriteNode(imageNamed: "missile")
    let fireblast = SKSpriteNode(imageNamed: "fireblast")
    var bg1 = SKSpriteNode(imageNamed: "bg")
    var bg2 = SKSpriteNode(imageNamed: "bg")
    var gameReady = false
    var score = 0
    var numJumps = 0
    var now : NSDate?
    var nextTime : NSDate?
    var bg1_lastX = CGFloat()
    var bg2_lastX = CGFloat()
    let backgroundVelocity : CGFloat = 5
    let scorelabel = SKLabelNode(fontNamed: "PerfectDarkBRK")
    var netActive = Bool()
    var currentHighScore = 0
    let highscorelabel = SKLabelNode(fontNamed: "PerfectDarkBRK")
    let tapToPlaylabel = SKLabelNode(fontNamed: "PerfectDarkBRK")
    var duckActive = Bool()
    var charChoice = ""
    var dodgeChoice = ""
    var clusterCount = 0
    var clusterHit = Bool()

    
    let f0 = SKTexture.init(imageNamed: "Panda_Run .01")
    let f1 = SKTexture.init(imageNamed: "Panda_Run .02")
    let f2 = SKTexture.init(imageNamed: "Panda_Run .03")
    let f3 = SKTexture.init(imageNamed: "Panda_Run .04")
    let f4 = SKTexture.init(imageNamed: "Panda_Run .05")
    let f5 = SKTexture.init(imageNamed: "Panda_Run .06")
    let f6 = SKTexture.init(imageNamed: "Panda_Run .07")
    let f7 = SKTexture.init(imageNamed: "Panda_Run .08")
    let f8 = SKTexture.init(imageNamed: "Panda_Run .09")
    let f9 = SKTexture.init(imageNamed: "Panda_Run .10")
    let f10 = SKTexture.init(imageNamed: "Panda_Run .11")
    let f11 = SKTexture.init(imageNamed: "Panda_Run .12")
    let f12 = SKTexture.init(imageNamed: "Panda_Run .13")
    let f13 = SKTexture.init(imageNamed: "Panda_Run .14")
    let f14 = SKTexture.init(imageNamed: "Panda_Run .15")
    let f15 = SKTexture.init(imageNamed: "Panda_Run .16")
    let f16 = SKTexture.init(imageNamed: "Panda_Run .17")
    let f17 = SKTexture.init(imageNamed: "Panda_Run .18")
    let f18 = SKTexture.init(imageNamed: "Panda_Run .19")
    let f19 = SKTexture.init(imageNamed: "Panda_Run .20")
    let f20 = SKTexture.init(imageNamed: "Panda_Run .21")
    let f21 = SKTexture.init(imageNamed: "Panda_Run .22")
    let f22 = SKTexture.init(imageNamed: "Panda_Run .23")
    let f23 = SKTexture.init(imageNamed: "Panda_Run .24")
    
    init(size: CGSize, char: String, score: Int, clusters: Int) {
        super.init(size: size)
        self.score = score
        charChoice = char
        clusterCount = clusters
        dodgeChoice = charChoice + "d"
//        print("IN GAMESCENE: " + charChoice)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameSetup(){
        self.backgroundColor = SKColor.whiteColor()
        
        dodgebutton.size     = CGSize(width: 100, height: 100)
        dodgebutton.position = CGPoint(x: 115, y: floor.frame.height / 2);
        dodgebutton.zPosition = 5
        dodgebutton.name = "dodgebutton"
        
        jumpbutton.size     = CGSize(width: 100, height: 100)
        jumpbutton.position = CGPoint(x: self.frame.width - 115, y: floor.frame.height / 2);
        jumpbutton.zPosition = 5
        jumpbutton.name = "jumpbutton"
        
        missilebutton.size     = CGSize(width: 100, height: 100)
        missilebutton.position = CGPoint(x: self.frame.width - 300, y: floor.frame.height / 2);
        missilebutton.zPosition = 5
        missilebutton.name = "missilebutton"
        
        fireballbutton.size     = CGSize(width: 100, height: 100)
        fireballbutton.position = CGPoint(x: 300, y: floor.frame.height / 2);
        fireballbutton.zPosition = 5
        fireballbutton.name = "fireballbutton"
        
        floor.xScale = 2
        floor.position = CGPoint(x: 0, y: floor.frame.height / 2);
        
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        floor.physicsBody?.collisionBitMask = PhysicsCategory.Player
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.dynamic = false
        
        
        
      
        let frames: [SKTexture] = [f0, f1, f2, f3, f4 ,f5 ,f6 , f7, f8, f9, f9, f10, f11, f12, f13, f14 , f15, f16, f16, f17, f18, f19, f20, f21, f22, f23]
        
        
        runner = SKSpriteNode(imageNamed: "Panda_Run .01")
        runner.position = CGPoint(x: self.frame.size.width / 10 , y: floor.frame.height);
        runner.size = CGSize(width: 200, height: 200)
        runner.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50,height: 80))
        runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
        runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
        runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
        runner.physicsBody?.affectedByGravity = true
        runner.physicsBody?.dynamic = true
        let animation = SKAction.animateWithTextures(frames, timePerFrame: 0.04)
        runner.runAction(SKAction.repeatActionForever(animation))

        
        
        let m = "Tap To Play"
        tapToPlaylabel.text = m
        tapToPlaylabel.fontSize = 100
        tapToPlaylabel.fontColor = SKColor.whiteColor()
        tapToPlaylabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 0.6)
        tapToPlaylabel.name = "tapToPlay"
        self.addChild(tapToPlaylabel)
        
        let message = "Score: \(score)"
        scorelabel.text = message
        scorelabel.fontSize = 40
        scorelabel.fontColor = SKColor.whiteColor()
        scorelabel.position = CGPoint(x: self.frame.width / 10, y: self.frame.height * 0.9)
        self.addChild(scorelabel)
        
        getCurrentHighScore()
        
        highscorelabel.text = "High Score: " + String(self.currentHighScore)
        highscorelabel.fontSize = 40
        highscorelabel.fontColor = SKColor.whiteColor()
        highscorelabel.position = CGPoint(x: self.frame.width - 190, y: self.frame.height * 0.9)
        self.addChild(highscorelabel)
        
        self.addChild(jumpbutton)
        self.addChild(dodgebutton)
        self.addChild(missilebutton)
        self.addChild(fireballbutton)


        self.addChild(runner)
        self.addChild(floor)
        
    }
    

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.removeAllChildren()
        self.physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity = CGVectorMake(0, -15)
        
        runAction(SKAction.waitForDuration(0.1), completion: {
            let backgroundMusic = SKAudioNode(fileNamed: "audio/cluster watch panda game loop.wav")
            backgroundMusic.autoplayLooped = true
            backgroundMusic.runAction(SKAction.changeVolumeTo(Float(0.7), duration: 0))
            self.addChild(backgroundMusic)
        })
        
        
        bg1.anchorPoint = CGPointZero
        bg1.position = CGPointZero
        bg1.size = self.frame.size
        bg1.zPosition = -1
        addChild(bg1)
        
        bg2.anchorPoint = CGPointZero
        bg2.position = CGPointMake(frame.size.width-1, 20)
        bg2.size = self.frame.size
        bg2.zPosition = -1
        addChild(bg2)
        
        gameSetup()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            if gameReady == false {
                gameReady = true
                for child in self.children
                {
                    if let spriteNode = child as? SKLabelNode {
                        if(spriteNode.name == "tapToPlay"){
                            self.removeChildrenInArray([child])
                        }
                    }
                }
            }
            else {
            
            let location = (touch).locationInNode(self)
//            print(touch.tapCount)
            
            if let name = self.nodeAtPoint(location).name {
                if( name == "dodgebutton"){
                    let flip = arc4random_uniform(2)
                    if flip == 0
                    {
                        runAction(SKAction.playSoundFileNamed("audio/Panda quack.wav", waitForCompletion: false))
                    }
                    else
                    {
                        runAction(SKAction.playSoundFileNamed("audio/Panda quack 2.wav", waitForCompletion: false))
                    }
                    
                    
                    runner.texture = SKTexture(imageNamed: dodgeChoice)
                    runner.size = CGSize(width: 80, height: 80)
                    runner.position.x = self.frame.width / 10
                    runner.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50,height: 50))
                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall// | PhysicsCategory.Cluster
                    runner.physicsBody?.affectedByGravity = true
                    runner.physicsBody?.dynamic = true
                    duckActive = true
                }
                else if( name == "missilebutton"){
                    runAction(SKAction.playSoundFileNamed("audio/magic attack.wav", waitForCompletion: false))
                    
                    missile.removeFromParent()
                    missile.size = CGSize(width: 100, height: 32)
                    missile.position = CGPoint(x: runner.position.x + runner.frame.width/2, y: runner.position.y - runner.frame.height/16)
                    missile.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "missile"), size: CGSize(width: 100, height: 32))
                    missile.physicsBody?.categoryBitMask = PhysicsCategory.Missile
                    missile.physicsBody?.collisionBitMask = PhysicsCategory.Wall
                    missile.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
                    missile.physicsBody?.affectedByGravity = false
                    missile.physicsBody?.dynamic = true
                    missile.physicsBody?.velocity = CGVectorMake(800, missile.position.y)
                    self.addChild(missile)
                } else if(name == "fireballbutton"){
                    runAction(SKAction.playSoundFileNamed("audio/fireball attack.wav", waitForCompletion: false))
                    
                    fireblast.removeFromParent()
                    fireblast.size = CGSize(width: 200, height: 80)
                    fireblast.position = CGPoint(x: runner.position.x , y: runner.position.y + runner.frame.height/1.4)
                    fireblast.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "fireblast"), size: CGSize(width: 200, height: 80))
                    fireblast.physicsBody?.categoryBitMask = PhysicsCategory.Fireblast
                    fireblast.physicsBody?.collisionBitMask = PhysicsCategory.Net
                    fireblast.physicsBody?.contactTestBitMask = PhysicsCategory.Net
                    fireblast.physicsBody?.affectedByGravity = false
                    fireblast.physicsBody?.dynamic = true
                    fireblast.physicsBody?.velocity = CGVectorMake(0, 300)
                    self.addChild(fireblast)
                }
             else if(name == "jumpbutton"){
                print("super pizza")
                if touch.tapCount <= 2 {
//                print(numJumps)
                if duckActive{
                    numJumps == 4
                } else {
                    if numJumps == 1 {
                        let rotation = SKAction.rotateByAngle( CGFloat(2 * -M_PI), duration: 0.75)
                        runner.runAction(rotation)
                    }
                    if numJumps < 2
                    {
                        runAction(SKAction.playSoundFileNamed("audio/Panda jump.wav", waitForCompletion: false))
                        runner.physicsBody?.velocity = CGVectorMake(0, runner.position.y + 400)
                        numJumps = numJumps + 1
                    }
                }
                
                }
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
//                    runner.texture = SKTexture(imageNamed: charChoice)
//                    runner.size = CGSize(width: 100, height: 100)
//                    runner.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: charChoice), size: CGSize(width: 100, height: 100))
//                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
//                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
//                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
//                    runner.physicsBody?.affectedByGravity = true
//                    runner.physicsBody?.dynamic = true
                    //numJumps = 0
                    
                    let frames: [SKTexture] = [f0, f1, f2, f3, f4 ,f5 ,f6 , f7, f8, f9, f9, f10, f11, f12, f13, f14 , f15, f16, f16, f17, f18, f19, f20, f21, f22, f23]
                    
                    
                   // runner = SKSpriteNode(imageNamed: "Panda_Run .01")
                    runner.position = CGPoint(x: self.frame.size.width / 10 , y: floor.frame.height);
                    runner.size = CGSize(width: 200, height: 200)
                    runner.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50,height: 80))
                    //texture: SKTexture(imageNamed: charChoice), size: CGSize(width: 100, height: 100)
                    runner.physicsBody?.categoryBitMask = PhysicsCategory.Player
                    runner.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
                    runner.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Spike | PhysicsCategory.Wall //| PhysicsCategory.Cluster
                    runner.physicsBody?.affectedByGravity = true
                    runner.physicsBody?.dynamic = true
                    let animation = SKAction.animateWithTextures(frames, timePerFrame: 0.04)
                    runner.runAction(SKAction.repeatActionForever(animation))

                    
                    duckActive = false
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
        if gameReady {
            let firstBody = contact.bodyA
            let secondBody = contact.bodyB
            if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Spike) ||
           (firstBody.categoryBitMask == PhysicsCategory.Spike && secondBody.categoryBitMask == PhysicsCategory.Player) ||
           (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Wall) ||
           (firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Player){
            let flip = arc4random_uniform(2)
            if flip == 0
            {
                runAction(SKAction.playSoundFileNamed("audio/Panda growl.wav", waitForCompletion: false))
            }
            else
            {
                runAction(SKAction.playSoundFileNamed("audio/Panda growl 3.wav", waitForCompletion: false))
            }
            
            let duration = 0.25
            let finalHeightScale:CGFloat = 0.0
            let scaleHeightAction = SKAction.scaleYTo(finalHeightScale, duration: duration)
            
            print("PLAYER HIT")
            gameReady = false
            runner.runAction(scaleHeightAction, completion: { () -> Void in })
            self.runAction(SKAction.fadeInWithDuration(1.0), completion: {
                
                self.removeAllChildren()
                self.addBG()
                
                
                let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                if(self.score > self.currentHighScore){
                    let fetchRequest = NSFetchRequest(entityName: "Scores")
                    let sortDescriptor = NSSortDescriptor(key: "score", ascending: true)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    do {
                        let result = try managedContext.executeFetchRequest(fetchRequest)
                        if result.count != 0 {
                            let managedObject = result[0]
                            managedObject.setValue(self.score, forKey: "score")
                            do{
                                print("SAVING NEW SCORE: " + String(self.score))
                                try managedContext.save()
                            } catch {
                                print("?")
                            }
                            
                        } else { //Create an entity
                            print("Creating Score entity")
                            let entityDescription =
                                NSEntityDescription.entityForName("Scores",
                                    inManagedObjectContext: managedContext)
                            
                            let newScore = Scores(entity: entityDescription!,
                                insertIntoManagedObjectContext: managedContext)
                            
                            newScore.score = self.score
                            
                            do{
                                try managedContext.save()
                            } catch {
                                print("?")
                            }
                        }
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                } else {
                    print("No new highscore set")
                }
                
                
                let fetchRequest = NSFetchRequest(entityName: "Clusters")
                let sortDescriptor = NSSortDescriptor(key: "cluster", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                do {
                    let result = try managedContext.executeFetchRequest(fetchRequest)
                    if result.count != 0 {
                        let cluster = result[0].valueForKey("cluster") as! NSNumber
                        print("Pizza " + String(self.clusterCount))
                        let val = Int(cluster) + (self.score / 10) + self.clusterCount
                        
                        let managedObject = result[0]
                        managedObject.setValue(val, forKey: "cluster")
                        do{
                            print("SAVING CLUSTER: " + String(val))
                            try managedContext.save()
                        } catch {
                            print("?")
                        }
                        
                    } else { //Create an entity
                        print("Creating Cluster entity")
                        let entityDescription =
                            NSEntityDescription.entityForName("Clusters",
                                inManagedObjectContext: managedContext)
                        
                        let numClusters = Clusters(entity: entityDescription!,
                            insertIntoManagedObjectContext: managedContext)
                        
                        numClusters.cluster = self.score / 10
                        
                        do{
                            try managedContext.save()
                        } catch {
                            print("?")
                        }
                    }
                } catch {
                    let fetchError = error as NSError
                    print(fetchError)
                }
 
                
                
                let transition:SKTransition = SKTransition.fadeWithDuration(1)
                let gameOverScene = GameOverScene(size: self.size, score: self.score, lastChar: self.charChoice)
                self.view?.presentScene(gameOverScene, transition: transition)
            })
        }
            if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Ground) || (firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Player)
            {
            if netActive == false{
                numJumps = 0
            }else{
                numJumps = 4
            }
        }
        

            if (firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Missile) || (firstBody.categoryBitMask == PhysicsCategory.Missile && secondBody.categoryBitMask == PhysicsCategory.Wall)
            {
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            }
        
            if (firstBody.categoryBitMask == PhysicsCategory.Net && secondBody.categoryBitMask == PhysicsCategory.Fireblast) || (firstBody.categoryBitMask == PhysicsCategory.Fireblast && secondBody.categoryBitMask == PhysicsCategory.Net)
            {
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            netActive = false
            numJumps = 0

            }
        
        
            if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Cluster){
            
                secondBody.node?.removeFromParent()
                if clusterHit == false{
                    runAction(SKAction.playSoundFileNamed("audio/Panda growl 2 (pick up).wav", waitForCompletion: false))
                        clusterCount += 1
                }
                clusterHit = true
                print(clusterCount)

            }
        else if (firstBody.categoryBitMask == PhysicsCategory.Cluster && secondBody.categoryBitMask == PhysicsCategory.Player)
        {
            firstBody.node?.removeFromParent()
            if clusterHit == false{
                runAction(SKAction.playSoundFileNamed("audio/Panda growl 2 (pick up).wav", waitForCompletion: false))
                clusterCount += 1
            }
            clusterHit = true
            print(clusterCount)

        }
        
        
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
        bg1.removeFromParent()
        bg2.removeFromParent()
        addBG()
        
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
    
    func generateCluster(){
        let cluster = SKSpriteNode(imageNamed: "glowclusters")
        let rnd = arc4random_uniform(200) + 200 // 0-5

        cluster.size = CGSize(width: 100, height: 100)
        cluster.position = CGPoint(x: self.frame.size.width, y: CGFloat(rnd));
        cluster.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "glowclusters"), size: CGSize(width: 100, height: 100))
        cluster.physicsBody?.categoryBitMask = PhysicsCategory.Cluster
        cluster.physicsBody?.collisionBitMask = PhysicsCategory.Player
        cluster.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        cluster.physicsBody?.affectedByGravity = false
        cluster.physicsBody?.dynamic = false
        cluster.physicsBody?.velocity = CGVectorMake(-50, CGFloat(rnd))
        let action = SKAction.moveTo(CGPoint(x:-50, y: Int(rnd)), duration: 5)
        cluster.runAction(action)
        clusterHit = false

        self.addChild(cluster)
    }
    
    
    func generateWall(){
        let wall = SKSpriteNode(imageNamed: "wall")
        
        wall.size = CGSize(width: 120, height: self.frame.height - floor.size.height)
        wall.position = CGPoint(x: self.frame.size.width, y: 320 + floor.size.height);
        wall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "wall"), size: CGSize(width: 40, height: self.frame.height - floor.size.height))
        wall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        wall.physicsBody?.collisionBitMask = PhysicsCategory.Missile
        wall.physicsBody?.contactTestBitMask = PhysicsCategory.Missile
        wall.physicsBody?.affectedByGravity = false
        wall.physicsBody?.dynamic = true
//        wall.physicsBody?.velocity = CGVectorMake(-1000, wall.position.y)
        
        let action = SKAction.moveTo(CGPoint(x:-300, y: floor.size.height + 320), duration: 2)
        wall.runAction(action)
        
        self.addChild(wall)
    }
    
    func generateNet(){
        if netActive{
        
        }else{
            let net = SKSpriteNode(imageNamed: "net")
            net.size = CGSize(width: 200, height: 80)
            net.position = CGPoint(x: runner.position.x, y: 400);
            net.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "net"), size: CGSize(width: 200, height: 80))
            net.physicsBody?.categoryBitMask = PhysicsCategory.Net
            net.physicsBody?.collisionBitMask = PhysicsCategory.Fireblast
            net.physicsBody?.contactTestBitMask = PhysicsCategory.Fireblast
            net.physicsBody?.affectedByGravity = false
            net.physicsBody?.dynamic = false
            net.physicsBody?.velocity = CGVectorMake(0, 0)
            netActive = true
            
            self.addChild(net)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        /* Called before each frame is rendered */
        if gameReady {
            
            bg1.position = CGPoint(x: bg1.position.x - 4, y: bg1.position.y)
            bg2.position = CGPoint(x: bg2.position.x - 4, y: bg2.position.y)

            if bg1.position.x < -frame.size.width
            {
                bg1.position = CGPointMake(bg2.position.x + frame.size.width, bg1.position.y)
            }
            
            if bg2.position.x < -frame.size.width
            {
                bg2.position = CGPointMake(bg1.position.x + frame.size.width, bg2.position.y)
            }
            
            bg1_lastX = bg1.position.x
            bg2_lastX = bg2.position.x
            
            if runner.position.x >= self.frame.width { runner.position.x = self.frame.width/10 }
            if runner.position.x <= 0 { runner.position.x = self.frame.width/10 }
            if runner.position.y >= self.frame.height - 140 { runner.position.y = self.frame.height - 140 }
        
            
            now = NSDate()
            if (now?.timeIntervalSince1970 > nextTime?.timeIntervalSince1970){
                let rnd = arc4random_uniform(6) // 0-5
                nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(2.0))
                
                
                
                if score <= 9 {
//                    print("Level 1 - "  + String(rnd))
                    generateSmallSpike()
                    if rnd == 4 {
                        generateCluster()
                    }
                } else if score <= 19 {
//                    print("Level 2 - " + String(rnd))
                    if rnd <= 3 {
                        generateSmallSpike()
                    } else if rnd == 4{
                        generateCluster()
                    } else {
                        generateLargeSpike()
                    }
                } else if score <= 29 {
//                    print("Level 3 - " + String(rnd))
                    if rnd <= 2 {
                        generateSmallSpike()
                    } else if rnd <= 4 {
                        generateLargeSpike()
                    } else {
                        generateCluster()
                        generateBullet()
                    }
                } else if score <= 39 {
//                    print("Level 4+ - " + String(rnd))
                    if rnd == 0 {
                        generateSmallSpike()
                    } else if rnd <= 2{
                        generateLargeSpike()
                    } else if rnd == 3{
                        generateBullet()
                        generateCluster()
                    } else if rnd == 4{
                        generateBullet()
                    } else{
                        generateWall()
                    }
                } else if score <= 49{
//                    print("Level 5+ - " + String(rnd))
                    if rnd == 0 {
                        generateSmallSpike()
                        generateCluster()
                    } else if rnd == 1{
                        generateLargeSpike()
                    } else if rnd == 2{
                        generateLargeSpike()
                        generateNet()
                    } else if rnd <= 4{
                        generateBullet()
                    } else {
                        generateWall()
                    }
                }else {
//                    print("Level 6+ - " + String(rnd))
                    if rnd == 0 {
                        generateSmallSpike()
                    } else if rnd == 1{
                        generateLargeSpike()
                        generateCluster()
                    } else if rnd == 2{
                        generateLargeSpike()
                        generateNet()
                    } else if rnd == 3{
                        generateBullet()
                    } else if rnd == 4{
                        generateWall()
                        generateBullet()
                    } else {
                        generateWall()
                        generateCluster()
                    }
                }
                
                
                
                checkIfObjReachesEnd()
            }
        }
        
       
        
        
        
    }
    
    
    
    func getCurrentHighScore(){
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Scores")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute Fetch Request
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            if result.count != 0 {
                let index = result.count
                currentHighScore = Int(result[index - 1].valueForKey("score") as! NSNumber)
//                print("Highscore: " + String(currentHighScore))
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func addBG()
    {
        if score <= 29{
        bg1 = SKSpriteNode(imageNamed: "bg")
//        bg1.name = "background"
        bg2 = SKSpriteNode(imageNamed: "bg")
//        bg2.name = "background"
        }
        else if score <= 49{
            bg1 = SKSpriteNode(imageNamed: "bg2")
            //        bg1.name = "background"
            bg2 = SKSpriteNode(imageNamed: "bg2")
            //        bg2.name = "background"
        }
        else {
            bg1 = SKSpriteNode(imageNamed: "bg3")
            //        bg1.name = "background"
            bg2 = SKSpriteNode(imageNamed: "bg3")
            //        bg2.name = "background"
        }

        bg1.anchorPoint = CGPointZero
        bg1.position = CGPointMake(bg1_lastX, bg1.position.y+70)
        bg1.size = self.frame.size
        bg1.zPosition = -1
        addChild(bg1)
        
        bg2.anchorPoint = CGPointZero
        bg2.position = CGPointMake(bg2_lastX, bg2.position.y+70)
        bg2.size = self.frame.size
        bg2.zPosition = -1
        addChild(bg2)
    }
}

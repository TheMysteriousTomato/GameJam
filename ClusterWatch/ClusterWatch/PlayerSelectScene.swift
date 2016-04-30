import SpriteKit

class PlayerSelectScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        
//        let bg = SKSpriteNode(imageNamed: "Menu")
//        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
//        bg.xScale = 2
//        bg.yScale = 2
//        bg.zPosition = -2
//        self.addChild(bg)
        
        let message = "Select your character:"
        let label = SKLabelNode(fontNamed: "PerfectDarkBRK")
        label.text = message
        label.fontSize = 80
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/1.5 )
        addChild(label)
        
        let c1 = SKLabelNode(fontNamed: "PerfectDarkBRK")
        c1.text = "runner"
        c1.fontSize = 40
        c1.name = "char"
        c1.position = CGPoint(x:CGRectGetMinX(self.frame) + 125, y:(CGRectGetMinY(self.frame) + 100))
        addChild(c1)
        
        let c2 = SKLabelNode(fontNamed: "PerfectDarkBRK")
        c2.text = "runner2"
        c2.fontSize = 40
        c2.name = "char"
        c2.position = CGPoint(x:CGRectGetMaxX(self.frame) / 2, y:(CGRectGetMinY(self.frame) + 100))
        addChild(c2)
        
        let c3 = SKLabelNode(fontNamed: "PerfectDarkBRK")
        c3.text = "runner3"
        c3.fontSize = 40
        c3.name = "char"
        c3.position = CGPoint(x:CGRectGetMaxX(self.frame) - 125, y:(CGRectGetMinY(self.frame) + 100))
        addChild(c3)
        
   
        
    }

    
    override func update(currentTime: CFTimeInterval) {
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if CGRectContainsPoint(self.frame, location) {
                if let name = self.nodeAtPoint(location).name {
                    if (name == "char"){
                        let label = self.nodeAtPoint(location) as! SKLabelNode
                        let char = label.text
                        runAction(SKAction.playSoundFileNamed("Sounds/hit.wav", waitForCompletion: false))
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        
                        let gameScene = GameScene(size: size, char: char!)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
        }
    }
    
    
}
import SpriteKit

class PlayerSelectScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "blackback")
        bg.position = CGPointMake(self.frame.width/2, self.frame.height/2);
        bg.size = CGSize(width: self.frame.width, height: self.frame.height)
        bg.zPosition = -2
        self.addChild(bg)
        
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
        c1.position = CGPoint(x:CGRectGetMinX(self.frame) + 125, y:(CGRectGetMaxY(self.frame) / 2 - 150))
        addChild(c1)
        
        let c1image = SKSpriteNode(imageNamed: "runner")
        c1image.size = CGSize(width: 150, height: 150)
        c1image.position = CGPoint(x:CGRectGetMinX(self.frame) + 125, y:(CGRectGetMaxY(self.frame) / 2))
        addChild(c1image)
        
        
        let c2 = SKLabelNode(fontNamed: "PerfectDarkBRK")
        c2.text = "runner2"
        c2.fontSize = 40
        c2.name = "char"
        c2.position = CGPoint(x:CGRectGetMaxX(self.frame) / 2, y:(CGRectGetMaxY(self.frame) / 2 - 150))
        addChild(c2)
        
        let c2image = SKSpriteNode(imageNamed: "runner2")
        c2image.size = CGSize(width: 150, height: 150)
        c2image.position = CGPoint(x:CGRectGetMaxX(self.frame) / 2, y:(CGRectGetMaxY(self.frame) / 2))
        addChild(c2image)
        
        let c3 = SKLabelNode(fontNamed: "PerfectDarkBRK")
        c3.text = "runner3"
        c3.fontSize = 40
        c3.name = "char"
        c3.position = CGPoint(x:CGRectGetMaxX(self.frame) - 125, y:(CGRectGetMaxY(self.frame) / 2 - 150))
        addChild(c3)
        
        let c3image = SKSpriteNode(imageNamed: "runner3")
        c3image.size = CGSize(width: 150, height: 150)
        c3image.position = CGPoint(x:CGRectGetMaxX(self.frame) - 125, y:(CGRectGetMaxY(self.frame) / 2))
        addChild(c3image)
   
        
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
                        runAction(SKAction.playSoundFileNamed("audio/menu click accept.wav", waitForCompletion: false))
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        
                        let gameScene = GameScene(size: size, char: char!)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
        }
    }
    
    
}
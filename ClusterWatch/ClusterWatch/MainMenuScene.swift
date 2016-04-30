import SpriteKit

class MainMenuScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        
        let bg = SKSpriteNode(imageNamed: "Menu")
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        bg.xScale = 2
        bg.yScale = 2
        bg.zPosition = -2
        self.addChild(bg)
        
        let message = "C L U S T E R   W A T C H"
        let label = SKLabelNode(fontNamed: "PerfectDarkBRK")
        label.text = message
        label.fontSize = 80
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/1.5 )
        addChild(label)
        
        let help = SKLabelNode(fontNamed: "PerfectDarkBRK")
        help.text = "HELP"
        help.fontSize = 80
        help.name = "help"
        help.position = CGPoint(x:CGRectGetMaxX(self.frame) - 75, y:(CGRectGetMinY(self.frame) + 100))
        addChild(help)
        
        let play = SKLabelNode(fontNamed: "PerfectDarkBRK")
        play.text = "PLAY"
        play.fontSize = 80
        play.name = "play"
        play.position = CGPoint(x: size.width/2, y: size.height/2 - 250)
        addChild(play)
        
        initializingMusic()
    }
    //Load Music
    func initializingMusic(){
        runAction(SKAction.waitForDuration(0.1), completion: {
            let backgroundMusic = SKAudioNode(fileNamed: "Sounds/main_menu_bg.mp3")
            backgroundMusic.autoplayLooped = true
            backgroundMusic.runAction(SKAction.changeVolumeTo(Float(0.7), duration: 0))
            self.addChild(backgroundMusic)
        })
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if CGRectContainsPoint(self.frame, location) {
                if let name = self.nodeAtPoint(location).name {
//                    if( name == "help"){
//                        runAction(SKAction.playSoundFileNamed("Sounds/hit.wav", waitForCompletion: false))
//                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
//                        let gameScene = HelpScene(size: size)
//                        self.view?.presentScene(gameScene, transition: transition)
//                    } else
                        if (name == "play"){
                        runAction(SKAction.playSoundFileNamed("Sounds/hit.wav", waitForCompletion: false))
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        let gameScene = GameScene(size: size)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
        }
    }
    
    
}
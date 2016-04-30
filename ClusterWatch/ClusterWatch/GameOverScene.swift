import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, score: Int) {
        
        super.init(size: size)
        
        
//        self.runAction(SKAction.fadeInWithDuration(2.5), completion: {
            let label = SKLabelNode(fontNamed: "PerfectDarkBRK")
            label.text = "Game Over"
            label.fontSize = 100
            label.fontColor = SKColor.whiteColor()
            label.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
            self.addChild(label)
            
            
            let message = "Score: \(score)"
            let score = SKLabelNode(fontNamed: "PerfectDarkBRK")
            score.text = message
            score.fontSize = 40
            score.fontColor = SKColor.whiteColor()
            score.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
            self.addChild(score)
            
            
            let playagain = SKLabelNode(fontNamed: "PerfectDarkBRK")
            playagain.text = "play again"
            playagain.name = "play"
            playagain.position = CGPoint(x: size.width/2, y: size.height/2 - 150)
            self.addChild(playagain)
        
            let homeScreen = SKLabelNode(fontNamed: "PerfectDarkBRK")
            homeScreen.text = "home"
            homeScreen.name = "home"
            homeScreen.position = CGPoint(x: size.width/2, y: size.height/2 - 250)
            self.addChild(homeScreen)

//        })
        
        
        
        
        //initializingMusic()
        
    }
    
    func intializeGameover(){
        
    }
    
    //Load Music
    func initializingMusic(){
        runAction(SKAction.playSoundFileNamed("Sounds/gamer_over_bg.mp3", waitForCompletion: false))
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            
            if CGRectContainsPoint(self.frame, location) {
                if let name = self.nodeAtPoint(location).name {
                    if(name == "play") {
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        let gameScene = GameScene(size: size)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                    if(name == "home") {
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        let gameScene = MainMenuScene(size: size)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                }
                
                
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
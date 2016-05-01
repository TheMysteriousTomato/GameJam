import Foundation
import SpriteKit
import CoreData

class GameOverScene: SKScene {
    var highscore = 0
    var clusterCount = 0
    var charChoice = ""
    
    init(size: CGSize, score: Int, lastChar: String) {
        super.init(size: size)
        charChoice = lastChar
        
        let bg = SKSpriteNode(imageNamed: "blackback")
        bg.position = CGPointMake(self.frame.width/2, self.frame.height/2);
        bg.size = CGSize(width: self.frame.width, height: self.frame.height)
        bg.zPosition = -2
        self.addChild(bg)
        
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
        
            getCurrentHighScore()
            getCurrentClusters()

        
            let clustCount = SKLabelNode(fontNamed: "PerfectDarkBRK")
            clustCount.text = "Cluster Count: " + String(clusterCount)
            clustCount.fontSize = 40
            clustCount.fontColor = SKColor.whiteColor()
            clustCount.position = CGPoint(x: size.width/2, y: size.height/2 + 30)
            self.addChild(clustCount)
        
            let hiscore = SKLabelNode(fontNamed: "PerfectDarkBRK")
            hiscore.text = "High Score: " + String(highscore)
            hiscore.fontSize = 40
            hiscore.fontColor = SKColor.whiteColor()
            hiscore.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
            self.addChild(hiscore)
        
        
            let playagain = SKSpriteNode(imageNamed: "playbutton")
            playagain.size = CGSize(width: 400, height: 100)
            playagain.name = "play"
            playagain.position = CGPoint(x: size.width/2, y: size.height/2 - 150)
            self.addChild(playagain)
        
            let homeScreen = SKSpriteNode(imageNamed: "homebutton")
            homeScreen.size = CGSize(width: 400, height: 100)
            homeScreen.name = "home"
            homeScreen.position = CGPoint(x: size.width/2, y: size.height/2 - 250)
            self.addChild(homeScreen)

//        })
        
        
        
        
        //initializingMusic()
        
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
            var index = result.count
            highscore = Int(result[index - 1].valueForKey("score") as! NSNumber)
//            print("Highscore: " + String(highscore))
//            for managedObject in result {
//                if let hi = managedObject.valueForKey("score"){
//                    //print("\(hi)")
//                    highscore = Int(hi as! NSNumber)
//                }
//            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func getCurrentClusters(){
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Clusters")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "cluster", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute Fetch Request
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            clusterCount = Int(result[0].valueForKey("cluster") as! NSNumber)
            //            print("Highscore: " + String(highscore))
            //            for managedObject in result {
            //                if let hi = managedObject.valueForKey("score"){
            //                    //print("\(hi)")
            //                    highscore = Int(hi as! NSNumber)
            //                }
            //            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
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
                        runAction(SKAction.playSoundFileNamed("audio/menu click.wav", waitForCompletion: false))
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        let gameScene = GameScene(size: size, char: charChoice)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                    if(name == "home") {
                        runAction(SKAction.playSoundFileNamed("audio/menu click.wav", waitForCompletion: false))
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
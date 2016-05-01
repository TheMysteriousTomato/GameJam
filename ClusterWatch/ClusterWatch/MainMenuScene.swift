import SpriteKit
import CoreData

class MainMenuScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Items")
        let sortDescriptor1 = NSSortDescriptor(key: "item1", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "item2", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "item3", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2, sortDescriptor3]
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            if result.count != 0 {
                let managedObject = result[0]
                managedObject.setValue(false, forKey: "item1")
                managedObject.setValue(false, forKey: "item2")
                managedObject.setValue(false, forKey: "item3")
                do{
                    print("SAVING Default Store states...")
                    try managedContext.save()
                } catch {
                    print("?")
                }
                
            } else { //Create an entity
                print("Creating Score entity")
//                let entityDescription =
//                    NSEntityDescription.entityForName("Items",
//                                                      inManagedObjectContext: managedContext)
//                
//                let newItem1 = Scores(entity: entityDescription!,
//                                      insertIntoManagedObjectContext: managedContext)
//                
//                newScore.score = self.score
//                
//                do{
//                    try managedContext.save()
//                } catch {
//                    print("?")
//                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        let bg = SKSpriteNode(imageNamed: "menuback")
        bg.position = CGPointMake(self.frame.width/2, self.frame.height/2);
        bg.size = CGSize(width: self.frame.width, height: self.frame.height)
        bg.zPosition = -2
        self.addChild(bg)
        
        let label = SKSpriteNode(imageNamed: "title")
        label.size = CGSize(width: 900, height: 180)
        label.position = CGPoint(x: size.width/2, y: size.height - 100 )
        addChild(label)
        
        let play = SKSpriteNode(imageNamed: "playbutton")
        play.size = CGSize(width: 400, height: 100)
        play.name = "play"
        play.position = CGPoint(x: size.width/2, y: size.height/2 - 200)
        addChild(play)
       
        let store = SKSpriteNode(imageNamed: "storebutton")
        store.size = CGSize(width: 400, height: 100)
        store.name = "store"
        store.position = CGPoint(x: size.width/2, y: size.height/2 - 315)
        addChild(store)
        
        initializingMusic()
    }
    //Load Music
    func initializingMusic(){
        runAction(SKAction.waitForDuration(0.1), completion: {
            let backgroundMusic = SKAudioNode(fileNamed: "audio/cluster to loop.wav")
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
                    if( name == "store"){
                        runAction(SKAction.playSoundFileNamed("audio/menu click.wav", waitForCompletion: false))
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        let gameScene = StoreScene(size: size)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                    if (name == "play"){
                        runAction(SKAction.playSoundFileNamed("audio/menu click.wav", waitForCompletion: false))
                        let transition:SKTransition = SKTransition.fadeWithDuration(2)
                        let gameScene = PlayerSelectScene(size: size)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
        }
    }
    
    
}
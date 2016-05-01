import SpriteKit
import CoreData

class MainMenuScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        


        let fetchRequest = NSFetchRequest(entityName: "Items")
        var items = [NSManagedObject]()
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            if results.count == 0 {
                print("Creating Store Entity")
                let entity =  NSEntityDescription.entityForName("Items",
                                                                inManagedObjectContext:managedContext)
                let item = NSManagedObject(entity: entity!,
                                           insertIntoManagedObjectContext: managedContext)
                
                item.setValue(false, forKey: "item1")
                item.setValue(false, forKey: "item2")
                item.setValue(false, forKey: "item3")
                
                do {
                    try managedContext.save()
                    print("Grabbing store items status")
                    items = results as! [NSManagedObject]
                    print(items[0].valueForKey("item1"))
                    print(items[0].valueForKey("item2"))
                    print(items[0].valueForKey("item3"))
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            if results.count != 0 {
                print("Grabbing store items status")
                items = results as! [NSManagedObject]
                print(items[0].valueForKey("item1"))
                print(items[0].valueForKey("item2"))
                print(items[0].valueForKey("item3"))
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
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
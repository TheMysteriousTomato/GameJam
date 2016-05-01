//
//  StoreScene.swift
//  ClusterWatch
//
//  Created by Adam Slater on 2016-04-30.
//  Copyright © 2016 themysterioustomato. All rights reserved.
//

import Foundation
import SpriteKit

class StoreScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        let button = SKSpriteNode(imageNamed: "playbutton")
        button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        button.name = "play"
        
        self.addChild(button)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            
            if CGRectContainsPoint(self.frame, location) {
                if let name = self.nodeAtPoint(location).name {
                    if(name == "play") {
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
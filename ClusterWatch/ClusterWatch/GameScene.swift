//
//  GameScene.swift
//  ClusterWatch
//
//  Created by Jon Deluz on 2016-04-29.
//  Copyright (c) 2016 themysterioustomato. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    func gameSetup(){
        let floor = SKSpriteNode(imageNamed: "floor")
        floor.xScale = 2
        floor.position = CGPoint(x: 0, y: floor.frame.height / 2);
        
        let runner = SKSpriteNode(imageNamed: "runner")
        runner.size = CGSize(width: 175, height: 175)
        runner.position = CGPoint(x: self.frame.size.width / 10, y: floor.frame.height + 100);
        
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
            let location = touch.locationInNode(self)
            

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

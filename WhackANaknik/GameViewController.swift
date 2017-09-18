//
//  GameViewController.swift
//  WhackANaknik
//
//  Created by neemdor semel on 18/08/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet weak var heartView1: UIImageView!
    @IBOutlet weak var heartView2: UIImageView!
    @IBOutlet weak var heartView3: UIImageView!
    var heart1:Bool = true
    var heart2:Bool = true
    var heart3:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                scene.viewController = self
                view.presentScene(scene)
            }
            heartView1.image = #imageLiteral(resourceName: "heart.png")
            heartView2.image = #imageLiteral(resourceName: "heart.png")
            heartView3.image = #imageLiteral(resourceName: "heart.png")
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let theDestination = (segue.destination as! EndViewController)
        theDestination.score = sender as? Int
    }
    func endGame(score: Int){
        performSegue(withIdentifier: "End Game", sender: score)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//
//  CaptureViewController.swift
//  pokemongo
//
//  Created by Brian Nguyen on 3/12/23.
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

class CaptureViewController: UIViewController {
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let scene = CaptureScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        self.view = SKView()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.pokemon = self.pokemon 
        
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.returnToMapView), name: NSNotification.Name("close"), object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func returnToMapView(){
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

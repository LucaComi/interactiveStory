//
//  ViewController.swift
//  interactiveStory
//
//  Created by luca cominato on 18/09/16.
//  Copyright © 2016 Luca Cominato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "startAdventure" {
            
            //qui io istanzio la mia viewCrontroller (pageController) della nuova view che devo mostrare
           if let pageController = segue.destinationViewController as? PageController {
                
                // Adventrure.story perchè un type property non deve essere istanziata 
                pageController.page = Adventure.story
            }
            
        }
    }
    
    
}


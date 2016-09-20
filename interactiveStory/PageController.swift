//
//  PageController.swift
//  interactiveStory
//
//  Created by luca cominato on 18/09/16.
//  Copyright © 2016 Luca Cominato. All rights reserved.
//

import UIKit

class PageController: UIViewController {
  
    var page: Page?
    
    // elementi per mostrare i vari elementi a livello di programmazione 
    
    // 1) immagine
    let artwork = UIImageView()
    
    // 2) label per il testo 
    let storyLabel = UILabel()
    
    // 3) i due bottoni per la scelta 
    
    let firstChoiceButton = UIButton(type: .System)
    let secondChoiceButton = UIButton(type: .System)
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    init(page: Page){
        self.page = page
        
        // gli dico di inizializzare una view controller e gli passo i valori nil poichè tale view è nella storyboard e non da altre parti 
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // page è stata instanziata nel metodo prepare for segue 
        if let page = page {
            artwork.image = page.story.artwork
            artwork.contentMode = UIViewContentMode.ScaleToFill
            storyLabel.text = page.story.text
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        /* quando io parto dalla mia storyboard vado nel mio utility box seleziono "image view" e lo trascino nella mia view controllor ", quella è una subview che deve essere aggiunta la inizializzo qui perchè se andassi a farlo nel mio metodo init dovrei ripetere del codice */
       
        // aggiungo la subview
        view.addSubview(artwork)
        
        /* nelle versioni precedenti di iOS venivano forniti una serie di vincoli standar questa funzione deve essere disabilitata sennò enntra in conflitto con i miei vincoli */
        
        artwork.translatesAutoresizingMaskIntoConstraints = false
        
        // devo aggiungere i vincoli, (originariamente avevo pensati di fissare i vincoli agli angoli e mantengo questa regola)
        
        // questo attiva un vincolo alla volta
        // artwork.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        
        
        // per attivare una seri di vincoli tutti in una volta 
        
        NSLayoutConstraint.activateConstraints([
            artwork.topAnchor.constraintEqualToAnchor(view.topAnchor),
            artwork.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            artwork.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            artwork.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            ])
        
        
        
        // Label 
        
        
        view.addSubview(storyLabel)
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // in questo modo si autogestisce le linee e quando non ci sta va a capo
        storyLabel.numberOfLines = 0
        
        
        NSLayoutConstraint.activateConstraints([
            
            storyLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 30.0),
            storyLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -30.0),
            storyLabel.topAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 48.0)
            ])
        
        
        
        
    }
    
    
    
}


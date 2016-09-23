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
        view.backgroundColor = UIColor.whiteColor()
        
        // page è stata instanziata nel metodo prepare for segue 
        if let page = page {
            artwork.image = page.story.artwork
            artwork.contentMode = UIViewContentMode.ScaleToFill
            // storyLabel.text = page.story.text
            
            
            // nodifico lo stile del paragrafo
            let attributedString = NSMutableAttributedString(string: page.story.text)
            let paragraphStyle = NSMutableParagraphStyle()
           
            
            paragraphStyle.lineSpacing = 20
            
            // aggiungo l'attributo alla mia string 
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            storyLabel.attributedText = attributedString
            
            // tutte le cose che trovo nell'inspector posso maneggiarle rapidamente accedendo direttamente all' istanza
            // la stringa la copio e incollo da internet
            storyLabel.font = setFont("HelveticaNeue-Thin", textDimension: 20)
            
            // posiziono i bottonisono degli optional devo usare if let statement 
            
            if let firstChoice = page.firstChoice {
                firstChoiceButton.setTitle(firstChoice.title, forState: UIControlState.Normal)
                firstChoiceButton.addTarget(self, action: #selector (PageController.loadFirstChoice), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                
            }else{
                // se è nil ho raggiunto la fine della mia storia quindi voglio tornare all'inizio 
                firstChoiceButton.setTitle("Play Again", forState: UIControlState.Normal)
                
                // quando arrivo alla fine devo avere la possibilità di tornare all prima pagina ossia di togliere tutte le view dalla mia pila 
                firstChoiceButton.addTarget(self, action: #selector(PageController.playAgain), forControlEvents: UIControlEvents.TouchUpInside)
                
            }
            
            
            
            
            
            if let secondChoice = page.secondChoice {
                secondChoiceButton.setTitle(secondChoice.title, forState: UIControlState.Normal)
                secondChoiceButton.addTarget(self, action: #selector(PageController.loadSeconChoice), forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            
            
            
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
            storyLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 20.0)
            ])
        
        
        // aggiungo i buttons 
        
        view.addSubview(firstChoiceButton)
        view.addSubview(secondChoiceButton)
        
        // disattivo le i vincoli creati in automatico per entrambi 
        
        firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        // setto i miei nuovi vincoli 
        
        // primo bottone
        
        NSLayoutConstraint.activateConstraints([
            firstChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -100),
            firstChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
            
            ])
        NSLayoutConstraint.activateConstraints([
            secondChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -40),
            secondChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
            
            ])
        
        
    }
    
    func loadFirstChoice () {
        // sono optional devo vedere se riesco ad effettuare l' unwrapping
        // page la devo cercare newlla viewController altrimenti non me la vedo sono fuori dallo scope
        
        if let page = page, firstChoice = page.firstChoice {
            
            // accedo alla pagina successiva 
            
            let nextPage = firstChoice.page
            
            // creo una istanza della pagController relativa alla pagina successiva
            
            let pageController = PageController(page: nextPage)
            
            // spingo la nuova view sulla pila
            navigationController?.pushViewController(pageController, animated: true)
            
            
        }
        
    }
        func loadSeconChoice () {
        
            if let page = page, secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
                let pageController = PageController(page: nextPage)
                
                // spingo la nuova view sulla pila
                
                navigationController?.pushViewController(pageController, animated: true)
                
            
            }
        
    }
    
    func playAgain () {
    // toglie tutte le view dalla pila 
        
        navigationController?.popToRootViewControllerAnimated(true)
    
    }
    
    
    
func setFont (fontName: String, textDimension: CGFloat) -> UIFont {
    
    if let font = UIFont(name: fontName, size: textDimension) {
    return font
    }else{
    let fontDefault = UIFont(name: "KannadaSangamMN-Bold ", size: 40)
    return fontDefault!
    }

  // aggiungo due metodi per chiamare il caricamento delle pagine nel momento in cui premo i due bottoni
}

// non devo uscire dall'ultima parentesi perchè esco dal view Controller



}

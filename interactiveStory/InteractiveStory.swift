//
//  InteractiveStory.swift
//  interactiveStory
//
//  Created by luca cominato on 18/09/16.
//  Copyright © 2016 Luca Cominato. All rights reserved.
//

import Foundation
import UIKit       // perchè' devo gestire le immagini 


enum Story {    // aggiungengo String creo dei rawValue che posso andare ad utilzzare per chiamare le immagini che ho bisogno
    
    case ReturnTrip (String)
    case TouchDown
    case Homeward
    case Rover (String)
    case Cave
    case Crate
    case Monster
    case Droid (String)
    case Home
    
    var rawValue: String {
        switch self {
        case .ReturnTrip: return "ReturnTrip"
        case .Homeward: return "Homeward"
        case .TouchDown: return "TouchDown"
        case .Rover: return "Rover"
        case .Cave: return "Cave"
        case .Crate: return "Crate"
        case .Monster: return "Monster"
        case .Droid: return "Droid"
        case .Home: return "Home"
        
        }
    
    
    }

}

extension Story {
    
    var artwork: UIImage {
    
        return UIImage(named: self.rawValue)!   // il nome degli enum case rispecchia quello delle immagini //uso il force unwrapping perchè non digito nulla se                              
                                                // i valori del caso enum sono corretti non c'è modo di sbagliare
    }
    
    // l'audio lo vado a inserire in questo file perchè e da qui che viene preso tutto il materiale 
    
    var soundEffectURL: NSURL {
        
        let fileName: String
        
        switch self {
        case .Home: fileName = "HappyEnding"
        case .Monster: fileName = "Ominous"
        default: fileName = "PageTurn"
            }
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "wav")!
        
        return NSURL(fileURLWithPath: path)
    }
    
    var text: String {
    
        switch self {                           // è un estesione di story quindi è come se facesse parte di Story // ergo posso usare self per riferimi agli        
                                                //  enum cases
        case .ReturnTrip(let name):
            return "On your return trip from studying Saturn's rings, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me \(name), you're my only hope.\""
        case .TouchDown:
            return "You deftly land your ship near where the distress signal originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a small crate."
        case .Homeward:
            return "You continue your course to Earth. Two days later, you receive a transmission from HQ saing that they have detected some sort of anomaly on the surface of Mars near an abandoned rover. They ask you to investigate, but ultimately the decision is yours because your mission has already run much longer than planned and supplies are low."
        case .Rover(let name):
            return "The rover is covered in dust and most of the solar panels are broken. But you are quite surprised to see the on-board system booted up and running. In fact, there is a message on the screen, have a look \(name)!!. \"Come to 28.2342, -81.08273\". These coordinates aren't far but you don't know if your oxygen will last there and back."
        case .Cave:
            return "Your EVA suit is equipped with a headlamp which you use to navigate to a cave. After searching for a while your oxygen levels are starting to get pretty low. You know you should go refill your tank, but there's a faint light up ahead."
        case .Crate:
            return "Unlike everything else around you the crate seems new and...alien. As you examine the create you notice something glinting on the ground beside it. Aha, a key! It must be for the crate..."
        case .Monster:
            return "You pick up the key and try to unlock the crate, but the key breaks off in the keyhole.You scream out in frustration! Your scream alerts a creature that captures you and takes you away..."
        case .Droid(let name):
            return "After a long walk slightly uphill, you end up at the top of a small crater. \(name) look around and are overjoyed to see your robot friend, Droid-S1124. It had been lost on a previous mission to Mars. You take it back to your ship and fly back to Earth."
        case .Home:
            return "You arrive home on Earth. While your mission was a success, you forever wonder what was sending that signal. Perhaps a future mission will be able to investigate."
        }
    }
}

class Page {

    let story: Story
    
    typealias Choice = (title: String, page: Page)   // Creo un istanza di se stessa Page non posso usare una struct devo usare una class
    
    var firstChoice: Choice?
    var secondChoice: Choice?
    
    init (story: Story){
    
        self.story = story
    }
}


extension Page {
 
// posso chiamarte un metodo con lo stesso nome di un altro se accetta parametri diversi

    func addChoice(title: String, story: Story) -> Page {
    let page = Page(story: story)
    return addChoice(title, page: page)
    
    }
    

    func addChoice (title: String, page: Page) -> Page {
        
        // questo è un helper methods che mi permette di aggiungere scelte qualora non vi siano
        switch (firstChoice, secondChoice) {
        
        // le due scelte hanno una possibile scelta quindi esco dallo swith statement e rilascio la page che stavo testando
        case (.Some,.Some): break
        case (.None,.None), (.None,.Some): firstChoice = (title, page)
        case (.Some,.None): secondChoice = (title,page)
        }
    return page
    }

}


struct Adventure {

    static func story(name: String) -> Page {
        let returnTrip = Page(story: .ReturnTrip(name))
        let touchdown = returnTrip.addChoice("Stop and Investigate", story: .TouchDown)
        let homeward = returnTrip.addChoice("continue Home to Earth", story: .Homeward)
        let rover = touchdown.addChoice("explore the rover", story: .Rover(name))
        let crate = touchdown.addChoice("Open the Crate", story: .Crate)
        
        // torno a una istanza già creata touchdown
        homeward.addChoice("Head back to Mars", page: touchdown)
        
        let home = homeward.addChoice("Continue Home to earth", story: .Home)
        let cave = rover.addChoice("Explore the Coordinates", story: .Cave)
        // se sono alla fine non mi serve creare altre istanze xke non andrò ulteriormente in profondità // con la dot notation vado in profondità 
        // uso il metodo con story quando voglio instanziare pagine nuove non ancora instanziate
        cave.addChoice("Contine towards faint light", story: .Droid(name))
        cave.addChoice("refill the ship and explore the rover", page: rover)
        rover.addChoice("Return to earth", page: home)
        crate.addChoice("Explore the Rover", page: rover)
        crate.addChoice("Use the Key", story: .Monster)
        
        // questa è listanza che torna 
        return returnTrip
    }

}










































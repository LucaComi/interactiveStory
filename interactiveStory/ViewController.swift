//
//  ViewController.swift
//  interactiveStory
//
//  Created by luca cominato on 18/09/16.
//  Copyright © 2016 Luca Cominato. All rights reserved.
//

import UIKit

// UITextFieldDelegate è un objective-C delegate protocolo che ha metodi opzionali quindi una volta implementati non ho la richiesta di aggiungere metodi/ istanze obbligatorie 

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldBottomConstrain: NSLayoutConstraint!
    
    
    
    enum Error: ErrorType {
    case NoName // si verifica quando si prova ad avviare senza prima avaere inserito il nome
    }
    
    
    
    
   
    @IBOutlet weak var inputText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "startAdventure" {
    
            
            do {
                if let name = inputText.text {
                    if name == "" {
                    throw Error.NoName
                    } // posso evitare di mettere un else clause viene marcato come errore e viene chiamata la finestra di errore quindi l'esecuzione viene bloccata
                    
                    //qui io istanzio la mia viewCrontroller (pageController) della nuova view che devo mostrare
                    if let pageController = segue.destinationViewController as? PageController {
                        
                        // Adventrure.story perchè un type property non deve essere istanziata
                        
                        
                        pageController.page = Adventure.story(name)
                        
                    }
                }
                
            } catch Error.NoName{
            
            let alertController = UIAlertController(title: "Errore", message: "Prego, Inserisci il tuo nome", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(action)
            
            // questo per mostrarlo a scermo
            presentViewController(alertController, animated: true, completion: nil)
                
            } catch let error {
            fatalError("\(error) cazzo ne so cosa non va")
            }
            
            
            
            
            
            }
        
        }
    
    func keyboardWillShow(notification: NSNotification) {
        
        // notification è un dictionary con key value pair // nella prima parte effettuo l'unwrapping ottenendo le info che mi servono nella seocnda parte ottengo il valore dal dizionario
        if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            // il valore mi serve come CGRect non come NSValue
            let keyboarFrame = keyboardFrameValue.CGRectValue()
            
            // lo animo sennè salta 
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstrain.constant = keyboarFrame.size.height - 70
                self.view.layoutIfNeeded()
            }
            
        
        }
    
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userDict = notification.userInfo, keyboardFrameValue = userDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            
            UIView.animateWithDuration(0.8) {
            self.textFieldBottomConstrain.constant = self.textFieldBottomConstrain.constant - keyboardFrame.size.height + 100
                self.view.layoutIfNeeded()
            
            }
        }
    
    }
    
    
    
    
    
    
    
    // UITextFieldDelegate 
    
    // vado a usare un metodo definito nel Delegate protocoll della text field 
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
    
    



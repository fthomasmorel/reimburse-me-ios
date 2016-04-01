//
//  AddPayeeViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class AddPayeeViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var validButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
        self.validButton.alpha = 0.5
        self.validButton.enabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.checkField()
        return textField.text!.characters.count + (string.characters.count - range.length) <= 15
    }

    func checkField(){
        if self.userNameTextField.text?.characters.count > 0 {
            self.validButton.alpha = 1
            self.validButton.enabled = true
            return
        }
        self.validButton.alpha = 0.5
        self.validButton.enabled = false
    }
    
    @IBAction func validAction(sender: AnyObject) {
        APIManager.getUserWithUserName(self.userNameTextField.text!) { (json) -> () in
            if let userID = json[kUserId] as? String{
                 APIManager.addPayeeWithId(userID, completion: { (json) -> () in
                    UserManager.fetchUser({ (result) -> () in
                        print("sucess")
                    })
                 })
            }
        }
    }
    
    func handleTapGesture(gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}




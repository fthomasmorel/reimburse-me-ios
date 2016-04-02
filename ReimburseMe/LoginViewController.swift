//
//  LoginViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 02/04/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:UIViewController{
    
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        validateButton.layer.borderColor = UIColor.whiteColor().CGColor
        validateButton.layer.borderWidth = 1
        validateButton.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(animated: Bool) {
        self.nameTextField.becomeFirstResponder()
    }
    
    @IBAction func validateAction(sender: AnyObject) {
        if let _name = nameTextField.text{
            if let _username = usernameTextField.text{
                let user = User(id: "", name: _name, username: _username, token: "", payees: [])
                ToastManager.startLoading()
                UserManager.createUser(user) { (completed) in
                    if(completed){
                        ToastManager.stopLoading()
                        ToastManager.alertWithMessage("Inscription réussie", completion: {
                            APIManager.loginCurrentUser({ (result) in
                                if result{
                                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
                                    UIApplication.sharedApplication().delegate?.window!!.rootViewController = viewController
                                }
                            })
                        })
                    }else{
                        ToastManager.stopLoading()
                        ToastManager.alertWithMessage("Une erreure s'est produite", completion: nil)
                    }
                }
            }
        }
    }

}
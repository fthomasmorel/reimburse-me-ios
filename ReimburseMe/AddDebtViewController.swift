//
//  AddDebtViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker

class AddDebtViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, ImagePickerDelegate, PayeeSelectDelegate{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var payeeButton: UIButton!
    
    var payeeID:String?
    var image:UIImage?
    let imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture1 = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.tableView.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "showCamera:")
        self.imageView.addGestureRecognizer(tapGesture2)
     
        self.validButton.enabled = false
        self.validButton.alpha = 0.5
        
        self.imagePickerController.imageLimit = 1
        self.imagePickerController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    var id:String
    var title:String
    var description:String
    var amount:Float
    var payee:String
    var payer:String
    var date:NSDate
    var photoURL:String
    var reimbursed:NSDate

*/
    
    @IBAction func validAction(sender: AnyObject) {
        let debt = Debt(
            id:"",
            title: self.titleTextField.text!,
            description: self.descriptionTextView.text,
            amount: Float(self.amountTextField.text!)!,
            payee: self.payeeID!,
            payer: UserManager.sharedInstance()!.id,
            date: NSDate(),
            photoURL: "",
            reimbursed: NSDate()
        )
        ToastManager.startLoading()
        APIManager.addDebt(debt) { (json) -> () in
            if let id = json[kDebtId] as? String{
                if let img = self.image{
                    APIManager.addImageDebtWithId(id, image: img, completion: { (json) -> () in
                        ToastManager.alertWithMessage("La créance à bien été ajoutée", completion: nil)
                        UserManager.fetchUser({ (result) -> () in
                            UserManager.fetchDebt({ (result) -> () in
                                UserManager.fetchNotification({ (result) in
                                    NSNotificationCenter.defaultCenter().postNotificationName("refreshAll", object: nil)
                                    ToastManager.stopLoading()
                                    self.clearForm()
                                })
                            })
                        })
                    })
                }
            }
        }

    }
    
    @IBAction func selectPayeeAction(sender: AnyObject) {
        let selecter = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PayeeSelectViewController") as! PayeeSelectViewController
        selecter.delegate = self
        self.presentViewController(selecter, animated: true, completion: nil)
    }
    
    func handleTapGesture(gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.checkFields()
        return textField.text!.characters.count + (string.characters.count - range.length) <= 15
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
                self.checkFields()
        return textView.text.characters.count + (text.characters.count - range.length) <= 200
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func checkFields(){
        if(titleTextField.text?.characters.count > 0){
            if(amountTextField.text?.characters.count > 0){
                if(descriptionTextView.text?.characters.count > 0){
                    if let _ = self.payeeID {
                        self.validButton.enabled = true
                        self.validButton.alpha = 1
                        return
                    }
                }
            }
        }
        self.validButton.enabled = true
        self.validButton.alpha = 0.5
    }
    
    func showCamera(gesture: UITapGestureRecognizer) {
        presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    func wrapperDidPress(images: [UIImage]){
        if let img = images.first{
            self.image = img
            self.imageView.image = img
            self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func doneButtonDidPress(images: [UIImage]){
        if let img = images.first{
            self.image = img
            self.imageView.image = img
            self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func cancelButtonDidPress(){
        self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSelectPayeeWithId(id:String, andName name:String){
        self.payeeID = id
        self.payeeButton.titleLabel!.text = name
    }
    
    func clearForm(){
        self.titleTextField.text = ""
        self.amountTextField.text = ""
        self.descriptionTextView.text = ""
        self.image = nil
        self.payeeID = nil
        self.payeeButton.titleLabel?.text = "Toucher ici pour selectionner un payeur"
        self.imageView.image = UIImage(named: "addImage")
        self.checkFields()
    }
}




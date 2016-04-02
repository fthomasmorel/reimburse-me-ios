//
//  DebtReaderViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 18/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class DebtReaderViewController: UIViewController{
    
    @IBOutlet weak var reimbursedDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var debt:Debt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DebtReaderViewController.handleTapGesture(_:)))
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.titleLabel.text = debt.title
        self.descriptionLabel.text = debt.description
        self.amountLabel.text = "\(debt.amount.format(".2")) €"
        self.dateLabel.text = "Le \(debt.date.toString())"
        if let date = self.debt.reimbursed{
            self.reimbursedDateLabel.text = "Remboursé le \(date.toString())"
        }
        APIManager.getImageFromName(debt.photoURL) { (image) in
            if let _ = image{
                self.imageView.image = image
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setDebt(debt:Debt){
        self.debt = debt
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        let reader = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ImageReaderViewController") as! ImageReaderViewController
        reader.setImage(self.imageView.image!)
        self.presentViewController(reader, animated: true, completion: nil)
    }
}


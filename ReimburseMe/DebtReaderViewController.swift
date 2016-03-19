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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        let reader = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ImageReaderViewController") as! ImageReaderViewController
        reader.setImage(self.imageView.image!)
//        self.navigationController?.pushViewController(reader, animated: true)
                    self.presentViewController(reader, animated: true, completion: nil)
    }
}


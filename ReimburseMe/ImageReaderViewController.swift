//
//  ImageReaderViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 18/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class ImageReaderViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var currentImage:UIImage!
    var lastScale:CGFloat = CGFloat(1)
    var contentOffset:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.imageView.image = self.currentImage
        self.contentOffset = self.scrollView.contentOffset.y
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        
    }
    
    func setImage(image:UIImage){
        self.currentImage = image
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}


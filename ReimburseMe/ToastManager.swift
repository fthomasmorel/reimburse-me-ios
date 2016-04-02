//
//  ToastManager.swift
//  ReimburseMe
//
//  Created by Florent TM on 01/04/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class ToastManager:AnyObject{
    
    static var loadingView:UIView!
    static var alertView:UIView!
    
    class func initToastManager(){
        
        let w = UIScreen.mainScreen().bounds.width
        let h = UIScreen.mainScreen().bounds.height
        
        loadingView = UIView(frame:CGRectMake(0,0,w,h))
        loadingView.alpha = 0.7
        loadingView.backgroundColor = .blackColor()
        
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loader.center = loadingView.center
        loader.startAnimating()
        
        loadingView.addSubview(loader)
        
        alertView = UIView(frame: CGRectMake(0,-20,w,80))
        alertView.backgroundColor = .whiteColor()
        alertView.layer.cornerRadius = 10
        
        alertView.layer.shadowColor = UIColor.blackColor().CGColor
        alertView.layer.shadowOpacity = 1
        alertView.layer.shadowOffset = CGSizeZero
        alertView.layer.shadowRadius = 10
        alertView.layer.shadowPath = UIBezierPath(rect: alertView.bounds).CGPath
        alertView.layer.shouldRasterize = true
    }
    
    class func startLoading(){
        UIApplication.sharedApplication().delegate?.window!!.addSubview(loadingView)
    }
    
    class func stopLoading(){
        loadingView.removeFromSuperview()
    }
    
    class func alertWithMessage(message:String, completion:(()->())?){
        let label = UILabel(frame:CGRectMake(0,5,alertView.frame.width,alertView.frame.height))
        label.textColor = .blackColor()
        label.text = message
        label.font = UIFont(name: "Kohinoor-Bangla", size: 17)
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        
        alertView.addSubview(label)
        alertView.frame = CGRectMake(0,-alertView.frame.width-20, alertView.frame.width, alertView.frame.height)
        
        UIApplication.sharedApplication().delegate?.window!!.windowLevel = UIWindowLevelStatusBar+1
        UIApplication.sharedApplication().delegate?.window!!.addSubview(alertView)
        
        UIView.animateWithDuration(0.5, animations: { 
            alertView.frame = CGRectMake(0,-20, alertView.frame.width, alertView.frame.height)
            }) { (finished) in
                UIView.animateWithDuration(0.5, delay: 4, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        alertView.frame = CGRectMake(0,-alertView.frame.width-20, alertView.frame.width, alertView.frame.height)
                    }, completion: { (finished) in
                        UIApplication.sharedApplication().delegate?.window!!.windowLevel = UIWindowLevelNormal
                        label.removeFromSuperview()
                        if let _ = completion{
                            completion!()
                        }
                })
        }
    }
}

//  [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:view];
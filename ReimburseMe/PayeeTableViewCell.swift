//
//  PayeeTableViewCell.swift
//  ReimburseMe
//
//  Created by Florent TM on 01/04/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

protocol PayeeDelegate{
    func didRemovePayee(id:Int)
}

class PayeeTableViewCell:UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var creditSumLabel: UILabel!
    @IBOutlet weak var debitSumLabel: UILabel!
    @IBOutlet weak var foregroundView: UIView!
    var originPoint:CGPoint!
    var id:Int!
    var delegate:PayeeDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.foregroundView.addGestureRecognizer(panGesture)
        self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    @IBAction func removeAction(sender: AnyObject) {
        self.delegate?.didRemovePayee(self.id)
    }
    
    func handlePanGesture(gesture:UIPanGestureRecognizer){
        switch(gesture.state){
        case .Began:
            self.originPoint = gesture.locationInView(self)
            break
        case .Changed:
            var frame = self.foregroundView.frame
            let newX = (self.originPoint).x - gesture.locationInView(self).x
            self.originPoint = gesture.locationInView(self)
            frame.origin.x -= newX
            if(frame.origin.x < -100){
                frame.origin.x = -100
            }else if(frame.origin.x > 0){
                frame.origin.x = 0
            }
            self.foregroundView.frame = frame
            break
        default:
            var frame = self.foregroundView.frame
            if abs(frame.origin.x) > 25{
                //anim
                frame.origin.x = -100
            }else{
                //anim
                frame.origin.x = 0
            }
            self.foregroundView.frame = frame
            break
        }
    }
}
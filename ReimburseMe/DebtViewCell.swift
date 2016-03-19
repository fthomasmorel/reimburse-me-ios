//
//  DebtViewCell.swift
//  ReimburseMe
//
//  Created by Florent TM on 18/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

protocol DebtCellDelegate{
    func didTouchDebtCell(id:Int)
    func didReimburseDebt(id:Int)
}

class DebtViewCell:UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var payeeLabel: UILabel!
    @IBOutlet weak var reimbursedImage: UIImageView!
    @IBOutlet weak var foregroundView: UIView!
    var id:Int!
    var delegate:DebtCellDelegate?
    
    var originPoint:CGPoint!
    
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
        if(selected){
            self.delegate?.didTouchDebtCell(self.id)
        }
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func reimburseAction(sender: AnyObject) {
        //reimburseDebt
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
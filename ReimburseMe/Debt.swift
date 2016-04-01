//
//  Debt.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation


let kDebtId             = "ID"
let kDebtTitle          = "title"
let kDebtDescription    = "description"
let kDebtAmount         = "amount"
let kDebtPayee          = "payee"
let kDebtPayer          = "payer"
let kDebtDate           = "date"
let kDebtPhotoURL       = "photoURL"
let kDebtReimbursed     = "Reimbursed"


struct Debt {
    var id:String
    var title:String
    var description:String
    var amount:Float
    var payee:String
    var payer:String
    var date:NSDate
    var photoURL:String
    var reimbursed:NSDate?
}

func getDebtFromJSON(json:Dictionary<String,AnyObject>) -> Debt?{
    guard let _id = json[kDebtId] as? String else {return nil}
    guard let _title = json[kDebtTitle] as? String else {return nil}
    guard let _amout = json[kDebtAmount] as? Float else {return nil}
    guard let _description = json[kDebtDescription] as? String else {return nil}
    guard let _payee = json[kDebtPayee] as? String else {return nil}
    guard let _payer = json[kDebtPayer] as? String else {return nil}
    guard let _photoURL = json[kDebtPhotoURL] as? String else {return nil}
    guard let _date = json[kDebtDate] as? String else {return nil}
    let reimbursedDate:NSDate?
    if let date = json[kDebtReimbursed] as? String{
        reimbursedDate = NSDate.dateFromISODateString(date)!
    }else{
        reimbursedDate = nil
    }
    
    return Debt(
        id: _id,
        title: _title,
        description: _description,
        amount: _amout,
        payee: _payee,
        payer: _payer,
        date: NSDate.dateFromISODateString(_date)!,
        photoURL: _photoURL,
        reimbursed: reimbursedDate
    )
}
 
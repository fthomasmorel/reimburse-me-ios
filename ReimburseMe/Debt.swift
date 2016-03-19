//
//  Debt.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation


let kDebtId             = "_id"
let kDebtTitle          = "title"
let kDebtDescription    = "description"
let kDebtAmount         = "amount"
let kDebtPayee          = "payee"
let kDebtPayer          = "payer"
let kDebtDate           = "date"
let kDebtPhotoURL       = "photoURL"
let kDebtReimbursed     = "reimbursed"


struct Debt {
    var id:String
    var title:String
    var description:String
    var amount:Float
    var payee:String
    var payer:String
    var date:NSDate
    var photoURL:String
    var reimbursed:NSDate
}

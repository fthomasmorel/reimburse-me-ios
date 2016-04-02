//
//  Notification.swift
//  ReimburseMe
//
//  Created by Florent TM on 02/04/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

let kNotificationId      = "ID"
let kNotificationContent = "content"
let kNotificationUser    = "user"
let kNotificationDate    = "date"
let kNotificationDebt    = "debt"


struct Notification {
    var id:String
    var content:String
    var user:String
    var date:NSDate
    var debt:Debt
}

func getNotificationFromJSON(json:Dictionary<String,AnyObject>) -> Notification?{
    guard let _id = json[kNotificationId] as? String else {return nil}
    guard let _content = json[kNotificationContent] as? String else {return nil}
    guard let _user = json[kNotificationUser] as? String else {return nil}
    guard let _debt = json[kNotificationDebt] as? Dictionary<String,AnyObject> else {return nil}
    guard let _date = json[kNotificationDate] as? String else {return nil}
    
    return Notification(
        id: _id,
        content: _content,
        user: _user,
        date: NSDate.dateFromISODateString(_date)!,
        debt: getDebtFromJSON(_debt)!
    )
}


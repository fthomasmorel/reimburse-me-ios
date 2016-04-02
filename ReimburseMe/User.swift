//
//  User.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

let kUserId         = "ID"
let kUserName       = "name"
let kUserUserName   = "username"
let kUserToken      = "token"
let kUserPayees     = "payees"

struct User {
    var id:String
    var name:String
    var username:String
    var token:String
    var payees:[String]
}

func getUserFromJSON(json:Dictionary<String,AnyObject>) -> User?{
    guard let _id = json[kUserId] as? String else {return nil}
    guard let _username = json[kUserUserName] as? String else {return nil}
    guard let _name = json[kUserName] as? String else {return nil}
    guard let _user_token = json[kUserToken] as? String else {return nil}
    if let _payees = json[kUserToken] as? [String]{
        return User(id: _id, name: _name, username: _username, token: _user_token, payees: _payees)
    }else{
        return User(id: _id, name: _name, username: _username, token: _user_token, payees: [])
    }
}

func getInitial(string:String) -> String{
    let words = string.componentsSeparatedByString(" ")
    let initials:[Character] = words.map { (string) -> Character in
        string.characters.first!
    }
    var res = ""
    for c in initials{
        res += "\(c)"
    }
    return res
}

extension NSDate{
    class func dateFromISODateString(dateString:String) -> NSDate?{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let posix = NSLocale(localeIdentifier:"en_US_POSIX")
        formatter.locale = posix
        return formatter.dateFromString(dateString)
    }
    
    func getMonthNumber() -> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        return components.month
    }
    
    func getDayNumber() -> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        return components.day
    }
    
    func toString() -> String{
        return "\(self.getDayNumber())/\(self.getMonthNumber())"
    }
}

extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

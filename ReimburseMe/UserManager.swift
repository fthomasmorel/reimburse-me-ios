//
//  UserManager.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

class UserManager:AnyObject{
    
    private static var instance:User?
    static var myDebts:[Debt] = []
    static var myCredits:[Debt] = []
    static var notifications:[Notification] = []
    
    class func sharedInstance() -> User?{
        if let user = instance{
            return user
        }
        return nil
    }
    
    class func fetchUser(completion:(result:Bool)->()){
        guard let user_id = NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as? String else {completion(result:false);return}
        guard let user_token = NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as? String else {return completion(result:false)}
        APIManager.getUserWithId(user_id) { (json) -> () in
            guard let _id = json[kUserId] as? String else {completion(result: false) ; return}
            guard let _username = json[kUserUserName] as? String else {completion(result: false) ; return}
            guard let _name = json[kUserName] as? String else {completion(result: false) ; return}
            let _payees:[String]!
            if let payees = json[kUserPayees] as? [String]{
                _payees = payees
            }else{
                _payees = []
            }
            instance = User(id: _id, name: _name, username: _username, token: user_token, payees: _payees)
            completion(result: true)
        }
    }
    
    class func fetchDebt(completion:(result:Bool)->()){
        myDebts.removeAll()
        APIManager.getMyDebts { (json) -> () in
            for debtJSON in json{
                if let debt = getDebtFromJSON(debtJSON){
                    myDebts.append(debt)
                }
            }
        }
        myCredits.removeAll()
        APIManager.getTheirDebts { (json) -> () in
            for debtJSON in json{
                if let debt = getDebtFromJSON(debtJSON){
                    myCredits.append(debt)
                }
            }
            completion(result: true)
        }
    }
    
    class func fetchNotification(completion:(result:Bool)->()){
        notifications.removeAll()
        APIManager.getNotification({ (json) in
            for notifJson in json{
                if let notif = getNotificationFromJSON(notifJson){
                    self.notifications.append(notif)
                }
            }
            completion(result:true)
        })
    }
    
    class func createUser(user:User, completion:(result:Bool)->()){
        APIManager.createUser(user) { (json) -> () in
            if let user = getUserFromJSON(json){
                NSUserDefaults.standardUserDefaults().setObject(user.id, forKey: kUserId)
                NSUserDefaults.standardUserDefaults().setObject(user.token, forKey: kUserToken)
                completion(result: true)
                instance = user
            }else{
                completion(result: false)
            }
        }
    }
       
    class func currentUserExist() -> Bool{
        return NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as? String != nil
    }
    
    class func computeCreditSumForUser(id:String) -> Float{
        return myCredits.filter { (debt) -> Bool in
            debt.payee == id
        }.reduce(0.0, combine: { (sum, debt) -> Float in
            return sum + debt.amount
        })
    }
    
    class func computeDebitSumForUser(id:String) -> Float{
        return myDebts.filter { (debt) -> Bool in
            debt.payee == id
            }.reduce(0.0, combine: { (sum, debt) -> Float in
                return sum + debt.amount
            })
    }
}
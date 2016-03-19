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
    
    class func sharedInstance() -> User?{
        if let user = instance{
            return user
        }
        return nil
    }
    
    class func initUser(completion:(result:Bool)->()){
        guard let user_id = NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as? String else {completion(result:false);return}
        guard let user_token = NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as? String else {return completion(result:false)}
        APIManager.getUserWithId(user_id) { (json) -> () in
            guard let _id = json[kUserId] as? String else {completion(result: false) ; return}
            guard let _username = json[kUserUserName] as? String else {completion(result: false) ; return}
            guard let _name = json[kUserName] as? String else {completion(result: false) ; return}
            guard let _payees = json[kUserPayees] as? [String] else {completion(result: false) ; return}
            instance = User(id: _id, name: _name, username: _username, token: user_token, payees: _payees)
            completion(result: true)
        }
    }
    
}
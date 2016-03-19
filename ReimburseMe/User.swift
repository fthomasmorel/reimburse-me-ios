//
//  User.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

let kUserId         = "_id"
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

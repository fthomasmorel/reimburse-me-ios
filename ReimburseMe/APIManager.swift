//
//  APIManager.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Alamofire
import Foundation

class APIManager:AnyObject {
    
    static let kAPIUrl = "http://localhost:9000"
    
    class func getDebtWithId(id:String, completion:(json:Dictionary<String,AnyObject>)->()){
        Alamofire.request(.GET, kAPIUrl + "/debt/" + id).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func cancelDebtWithId(id:String, completion:(json:Dictionary<String,AnyObject>)->()){
        Alamofire.request(.DELETE, kAPIUrl + "/debt/" + id).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func addImageDebtWithId(id:String, image:UIImage, completion:(json:Dictionary<String,AnyObject>)->()){
        let imageData = UIImageJPEGRepresentation(image, 1)
        let urlRequest = urlRequestWithComponents(kAPIUrl + "/debt/" + id + "/image", parameters: ["":""], imageData: imageData!)
        Alamofire.upload(urlRequest.0, data: urlRequest.1).responseJSON { response in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func reimburseDebtWithId(id:String, completion:(json:Dictionary<String,AnyObject>)->()){
        Alamofire.request(.PUT, kAPIUrl + "/debt/" + id).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func getMyDebts(completion:(json:Dictionary<String,AnyObject>)->()){
        let user_id = UserManager.sharedInstance()!.id
        Alamofire.request(.GET, kAPIUrl + "/user/" + user_id + "/mydebt" ).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func getTheirDebts(completion:(json:Dictionary<String,AnyObject>)->()){
        let user_id = UserManager.sharedInstance()!.id
        Alamofire.request(.GET, kAPIUrl + "/user/" + user_id + "/debt" ).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func addDebt(debt:Debt, completion:(json:Dictionary<String, AnyObject>)->()){
        let param:[String:AnyObject] = [
            kDebtTitle:debt.title,
            kDebtDescription:debt.description,
            kDebtAmount:debt.amount,
            kDebtPayee:debt.payee,
            kDebtPayer:debt.payer
        ]
        let user_id = UserManager.sharedInstance()!.id
        Alamofire.request(.POST, kAPIUrl + "/user/" + user_id + "/debt", parameters:param).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func loginCurrentUser(completion:(json:Dictionary<String, AnyObject>)->()){
        let user_id = UserManager.sharedInstance()!.id
        let token = UserManager.sharedInstance()!.token
        Alamofire.request(.GET, kAPIUrl + "/user/" + user_id + "/login/" + token ).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func getUserWithId(id:String, completion:(json:Dictionary<String, AnyObject>)->()){
        Alamofire.request(.GET, kAPIUrl + "/user/" + id ).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func deleteCurrentUser(completion:(json:Dictionary<String, AnyObject>)->()){
        let user_id = UserManager.sharedInstance()!.id
        Alamofire.request(.DELETE, kAPIUrl + "/user/" + user_id ).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func createUser(user:User, completion:(json:Dictionary<String, AnyObject>)->()){
        let param = [
            kUserName:user.name,
            kUserUserName:user.username,
        ]
        Alamofire.request(.POST, kAPIUrl + "/user", parameters:param).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    
    class func addPayeeWithId(id:String, completion:(json:Dictionary<String, AnyObject>)->()){
        let user_id = UserManager.sharedInstance()!.id
        Alamofire.request(.POST, kAPIUrl + "/user/" + user_id + "/payee/" + id).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    class func deletePayeeWithId(id:String, completion:(json:Dictionary<String, AnyObject>)->()){
        let user_id = UserManager.sharedInstance()!.id
        Alamofire.request(.DELETE, kAPIUrl + "/user/" + user_id + "/payee/" + id).responseJSON { response -> Void in
            if let json = response.result.value {
                completion(json: json as! Dictionary<String, AnyObject>)
            }
        }
    }
    
    
    ////// HELPER
    
    class func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"uploadfile\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }

    
    
}
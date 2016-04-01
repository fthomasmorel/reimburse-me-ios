//
//  PayeeSelectViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 19/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

protocol PayeeSelectDelegate{
    func didSelectPayeeWithId(id:String, andName name:String)
}

class PayeeSelectViewController: UITableViewController{
    
    var delegate:PayeeSelectDelegate?
    var data:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        if let currentUser = UserManager.sharedInstance(){
            for userID in currentUser.payees{
                APIManager.getUserWithId(userID, completion: { (json) -> () in
                    if let user = getUserFromJSON(json){
                       self.data.append(user)
                       self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel!.text = self.data[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.data[indexPath.row]
        self.delegate?.didSelectPayeeWithId(user.id, andName: user.name)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func dismissAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}




//
//  PayeeTableViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 01/04/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class PayeeTableViewController: UITableViewController, PayeeDelegate{
    
    var users:[User] = []
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "PayeeTableViewCell"
        var cell: PayeeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? PayeeTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "PayeeTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? PayeeTableViewCell
        }
        cell.delegate = self
        cell.id = indexPath.row
        cell.usernameLabel.text = "@\(users[indexPath.row].username)"
        cell.nameLabel.text = users[indexPath.row].name
        cell.debitSumLabel.text = "\(UserManager.computeDebitSumForUser(users[indexPath.row].id).format(".2")) €"
        cell.creditSumLabel.text = "\(UserManager.computeCreditSumForUser(users[indexPath.row].id).format(".2")) €"
        return cell
    }
    
    func refreshData(){
        if let usersID = UserManager.sharedInstance()?.payees{
            self.users = []
            for id in usersID{
                APIManager.getUserWithId(id, completion: { (json) in
                    if let user = getUserFromJSON(json){
                        self.users.append(user)
                        self.tableView.reloadData()
                        print("finished")
                    }
                })
            }
        }
        self.tableView.reloadData()
    }
    
    func didRemovePayee(id:Int){
        let user = users[id]
        APIManager.deletePayeeWithId(user.id) { (json) in
            UserManager.fetchUser({ (result) in
                self.refreshData()
            })
        }
    }
}




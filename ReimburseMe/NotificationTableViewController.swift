//
//  NotificationTableViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 02/04/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class NotificationTableViewController: UITableViewController{
    
    var notifications:[Notification] = []
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "NotificationTableViewCell"
        var cell: NotificationTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? NotificationTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? NotificationTableViewCell
        }
        cell.contentLabel.text = self.notifications[indexPath.row].content
        cell.dateLabel.text = self.notifications[indexPath.row].date.toString()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let reader = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DebtReaderViewController") as! DebtReaderViewController
        reader.setDebt(self.notifications[indexPath.row].debt)
        self.navigationController?.pushViewController(reader, animated: true)
    }
    
    func refreshData(){
        self.notifications = UserManager.notifications
        self.tableView.reloadData()
    }
}




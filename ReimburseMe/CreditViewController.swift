//
//  CreditViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 18/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class CreditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CreditCellDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier = "CreditViewCell"
        var cell: CreditViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CreditViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "CreditViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CreditViewCell
        }

        cell.delegate = self
        cell.id = indexPath.row
        //Do something with the cell
        
        return cell
    }
    
    func didTouchCreditCell(id:Int){
        if(self.navigationController?.topViewController! == self){
            let reader = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DebtReaderViewController")
            self.navigationController?.pushViewController(reader, animated: true)
        }
    }
    
    func didCancelDebt(id:Int){
        
    }
}


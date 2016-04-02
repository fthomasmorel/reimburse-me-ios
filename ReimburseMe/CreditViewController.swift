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
        NSNotificationCenter.defaultCenter().addObserver(self.tableView, selector: #selector(UITableView.reloadData), name: "refreshAll", object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CreditViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
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
        return UserManager.myCredits.count
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
        cell.titleLabel.text = UserManager.myCredits[indexPath.row].title
        cell.amountLabel.text = "\(UserManager.myCredits[indexPath.row].amount.format(".2")) €"
        
        if UserManager.myCredits[indexPath.row].reimbursed == nil{
            cell.reimbursedImage.hidden = true
        }else{
            cell.reimbursedImage.hidden = false
        }
        
        cell.closeCell()
        cell.dateLabel.text = UserManager.myCredits[indexPath.row].date.toString()
        
        APIManager.getUserWithId(UserManager.myCredits[indexPath.row].payee) { (json) -> () in
            if let user = getUserFromJSON(json){
                cell.payeeLabel.text = getInitial(user.name)
            }
        }
        return cell
    }
    
    func didTouchCreditCell(id:Int){
        if(self.navigationController?.topViewController! == self){
            let reader = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DebtReaderViewController") as! DebtReaderViewController
            reader.setDebt(UserManager.myCredits[id])
            self.navigationController?.pushViewController(reader, animated: true)
        }
    }
    
    func didCancelDebt(id:Int){
        let debt = UserManager.myCredits[id]
        ToastManager.startLoading()
        APIManager.cancelDebtWithId(debt.id) { (json) -> () in
            ToastManager.alertWithMessage("La créance à bien été annulée", completion: nil)
            UserManager.fetchUser({ (result) -> () in
                UserManager.fetchDebt({ (result) -> () in
                    UserManager.fetchNotification({ (result) in
                        NSNotificationCenter.defaultCenter().postNotificationName("refreshAll", object: nil)
                        ToastManager.stopLoading()
                        self.tableView.reloadData()
                    })
                })
            })
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        UserManager.fetchDebt { (result) in
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}


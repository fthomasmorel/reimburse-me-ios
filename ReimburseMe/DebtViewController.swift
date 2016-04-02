//
//  CreditViewController.swift
//  ReimburseMe
//
//  Created by Florent TM on 18/03/2016.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class DebtViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DebtCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self.tableView, selector: #selector(UITableView.reloadData), name: "refreshAll", object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DebtViewController.refresh(_:)), forControlEvents: .ValueChanged)
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
        return UserManager.myDebts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier = "DebtViewCell"
        var cell: DebtViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? DebtViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "DebtViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? DebtViewCell
        }
        
        cell.delegate = self
        cell.id = indexPath.row

        cell.titleLabel.text = UserManager.myDebts[indexPath.row].title
        cell.amountLabel.text = "\(UserManager.myDebts[indexPath.row].amount.format(".2")) €"
        
        if UserManager.myDebts[indexPath.row].reimbursed == nil{
            cell.reimbursedImage.hidden = true
            cell.swipeEnabled = true
        }else{
            cell.reimbursedImage.hidden = false
            cell.swipeEnabled = false
        }
        
        cell.closeCell()
        cell.dateLabel.text = UserManager.myDebts[indexPath.row].date.toString()
        
        APIManager.getUserWithId(UserManager.myDebts[indexPath.row].payee) { (json) -> () in
            if let user = getUserFromJSON(json){
                cell.payeeLabel.text = getInitial(user.name)
            }
        }
        
        return cell
    }
    
    func didTouchDebtCell(id:Int){
        if(self.navigationController?.topViewController! == self){
            let reader = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DebtReaderViewController") as! DebtReaderViewController
            reader.setDebt(UserManager.myDebts[id])
            self.navigationController?.pushViewController(reader, animated: true)
        }
    }
    
    func didReimburseDebt(id:Int){
        let debt = UserManager.myDebts[id]
        ToastManager.startLoading()
        APIManager.reimburseDebtWithId(debt.id) { (json) -> () in
                ToastManager.alertWithMessage("La créance à bien été remboursée", completion: nil)
                UserManager.fetchUser({ (result) -> () in
                    UserManager.fetchDebt({ (result) -> () in
                        UserManager.fetchNotification({ (result) in
                            NSNotificationCenter.defaultCenter().postNotificationName("refreshAll", object: nil)
                            ToastManager.stopLoading()
                        })
                    })
                })
                self.tableView.reloadData()
            }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        UserManager.fetchDebt { (result) in
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}


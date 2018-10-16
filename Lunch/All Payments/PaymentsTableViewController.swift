//
//  PaymentsTableViewController.swift
//  Lunch
//
//  Created by Davide Castello on 12/10/2018.
//  Copyright © 2018 Davide Castello. All rights reserved.
//

import UIKit
import RealmSwift

class PaymentsTableViewController: UITableViewController {

  var payments: [Payment] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    title = Constants.allPayments
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    self.navigationItem.rightBarButtonItem?.title = Constants.edit
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    self.navigationItem.rightBarButtonItem?.title = (editing) ? Constants.done : Constants.edit
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    payments = Array(Payment.getOrderedPayments())
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return payments.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCellIdentifier", for: indexPath) as! PaymentTableViewCell
    cell.setPayment(payment: payments[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      Payment.deletePayment(payment: payments.remove(at: indexPath.row))
      tableView.deleteRows(at: [indexPath], with: .fade)
      UIView.transition(with: tableView, duration: Constants.animationsDuration, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
    }
  }
  
}

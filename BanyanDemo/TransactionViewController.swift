//
//  TransactionViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import UIKit
import AWSCore

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var transactionTableView: UITableView!
  @IBOutlet weak var environmentSegment: UISegmentedControl!
  let refreshControl = UIRefreshControl()
  var transactions = [AWSTransaction]()
  private var awsEnvironment = AWSEnvironment.development
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpSegmentView()
    setUpTableView()
    title = "Transactions"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    manualRefresh()
  }
  
  private func setUpSegmentView() {
    environmentSegment.isHidden = true
    
    environmentSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                              for: .selected)
    environmentSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                              for: .normal)
  }
  
  private func setUpTableView() {
    transactionTableView.backgroundColor = .white
    transactionTableView.tableFooterView = UIView()
    transactionTableView.refreshControl = refreshControl
    transactionTableView.refreshControl?.tintColor = .darkGray
    transactionTableView.refreshControl?.addTarget(self,
                                                   action: #selector(getTransactionData),
                                                   for: .valueChanged)
  }
  
  @objc
  private func getTransactionData() {
    AWSTransactionManager.getTransactionData(fromEnvironment: .laboratory) { [weak self] (awsTransactions, error) in
      guard let awsTransactions = awsTransactions else {
        if let error = error {
          print("ERROR IN CONNECTING WITH DB: \(error.userInfo)")
          
          DispatchQueue.main.async {
            self?.handleError()
          }
        }
        return
      }
      
      DispatchQueue.main.async {
        self?.transactions = awsTransactions
        self?.transactionTableView.reloadData()
        self?.completeRefresh()
      }
    }
  }
  
  private func completeRefresh() {
    self.transactionTableView.refreshControl?.endRefreshing()
  }
  
  private func handleError() {
    completeRefresh()
    let alert = UIAlertController(title: "Error", message: "There was an error in connecting to DynamoDB, please try again later", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("\(transactions.count) Transactions to load")
    return transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier) as! TransactionTableViewCell
    cell.initializeCell(withTransaction: transactions[indexPath.row])
    return cell
  }
  
  @IBAction func segmentChangedAction(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      awsEnvironment = .development
    }
    else {
      awsEnvironment = .laboratory
    }

    manualRefresh()
  }
  
  private func manualRefresh() {
    DispatchQueue.main.async {
      self.transactionTableView.setContentOffset(CGPoint(x: 0,
                                                         y: self.transactionTableView.contentOffset.y - (self.refreshControl.frame.size.height)),
                                                         animated: true)
      self.transactionTableView.refreshControl?.beginRefreshing()
      self.getTransactionData()
    }
  }
}

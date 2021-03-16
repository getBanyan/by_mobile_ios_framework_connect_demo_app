//
//  TransactionViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import UIKit
import AWSCore

enum AWSEnvironment {
  case development
  case laboratory
}

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var transactionTableView: UITableView!
  @IBOutlet weak var environmentSegment: UISegmentedControl!
  let refreshControl = UIRefreshControl()
  private var awsEnvironment = AWSEnvironment.development
  private var cognitoId = "us-east-1:b244ca7b-9f4f-45fd-b3d1-fda5bbaaa36d"
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpSegmentView()
    setUpTableView()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    simulateTablePull()
  }
  
  private func setUpSegmentView() {
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
                                                   action: #selector(didPullToRefresh),
                                                   for: .valueChanged)
  }
  
  private func getTransactionData() {
    AWSTransactionManager.getTransactionData()
    didPullToRefresh()
  }
  
  @objc
  private func didPullToRefresh() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.transactionTableView.refreshControl?.endRefreshing()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier) as! TransactionTableViewCell
    return cell
  }
  
  @IBAction func segmentChangedAction(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      awsEnvironment = .development
      cognitoId = "us-east-1:b244ca7b-9f4f-45fd-b3d1-fda5bbaaa36d"
    }
    else {
      awsEnvironment = .laboratory
      cognitoId = "us-east-1:602956b1-c5e3-41b3-9bdf-a87bce26feb6"
    }

    simulateTablePull()
  }
  
  private func simulateTablePull() {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.transactionTableView.setContentOffset(CGPoint(x: 0,
                                                         y: self.transactionTableView.contentOffset.y - (self.refreshControl.frame.size.height)),
                                                         animated: true)
      self.transactionTableView.refreshControl?.beginRefreshing()
      self.getTransactionData()
    }
  }
}

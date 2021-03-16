//
//  MenuViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import UIKit

class MenuViewController: UIViewController {

  @IBAction func showTransactionsButton() {
    let transactionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "transactionVC")
    self.navigationController?.pushViewController(transactionVC, animated: true)
  }
  
  @IBAction func goToDashboardButton() {
    let transactionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "dashboardVC")
    self.navigationController?.pushViewController(transactionVC, animated: true)
  }
}

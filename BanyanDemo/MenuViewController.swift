//
//  MenuViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import UIKit

class MenuViewController: UIViewController {
  
  // If we sign into one cognito sesson, we cannot change, so we need to restart
  var openedDashboard = false
  var openedTransactions = false
  var alertView = UIAlertController()
  var warningTimerCurrent = 5
  
  @IBAction func showTransactionsButton() {
    if !openedDashboard {
      openedTransactions = true
      let transactionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "transactionVC")
      self.navigationController?.pushViewController(transactionVC, animated: true)
    }
    else {
      showRestartPopup()
    }
  }
  
  @IBAction func goToDashboardButton() {
    if !openedTransactions {
      openedDashboard = true
      let transactionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "dashboardVC")
      self.navigationController?.pushViewController(transactionVC, animated: true)
    }
    else {
      showRestartPopup()
    }
  }
  
  func showRestartPopup() {
    Timer.scheduledTimer(timeInterval: 1, target:self ,
                                     selector: #selector(warningCheck),
                                     userInfo: nil,
                                     repeats: true)
    
    alertView = UIAlertController(title: "App Quitting in \(warningTimerCurrent)",
                                  message: "AWS Cognito credentials needs to be reset for you to access that module.\nThe app needs to quit completely and restart.",
                                  preferredStyle: .alert)
    
    present(alertView, animated: true, completion: nil)
  }
  
  @objc
  func warningCheck() {
    if warningTimerCurrent != 0 {
      warningTimerCurrent -= 1
      alertView.title = "App Quitting in \(warningTimerCurrent)"
    }
    else {
      fatalError()
    }
  }
}

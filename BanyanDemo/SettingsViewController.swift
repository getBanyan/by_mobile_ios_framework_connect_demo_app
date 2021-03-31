//
//  SettingsViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 12/03/2021.
//

import UIKit
import BYConnect

protocol SettingsDelegate: class {
  func changeEnvironment(_ environment: BYEnvironment) // add any necessary parameters
}

class SettingsViewController: UIViewController {
  
  var currentEnvironment: BYEnvironment!
  var newEnvironment: BYEnvironment!
  var alertView = UIAlertController()
  var warningTimerCurrent = 5
  
  @IBOutlet weak var environmentSegment: UISegmentedControl!
  weak var settingsDelegate: SettingsDelegate?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    for view in view.subviews {
      if let segmentView = view as? UISegmentedControl {
        segmentView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
      }
    }
    
    if currentEnvironment == .Development {
      environmentSegment.selectedSegmentIndex = 0
    }
    else {
      environmentSegment.selectedSegmentIndex = 1
    }
  }
  
  @IBAction func doneButtonTapped(_ sender: Any) {
    if currentEnvironment == newEnvironment {
      dismiss(animated: true, completion: nil)
    }
    else {
      UserDefaults.standard.setValue(newEnvironment.rawValue, forKey: "environment")
      showRestartPopup()
    }
  }
  
  @IBAction func segmentSet(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      newEnvironment = .Development
    }
    else {
      newEnvironment = .Laboratory
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

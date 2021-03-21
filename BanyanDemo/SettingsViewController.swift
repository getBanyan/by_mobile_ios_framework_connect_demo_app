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
  
  @IBOutlet weak var environmentSegment: UISegmentedControl!
  var currentEnvironment: BYEnvironment = .Development
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
    settingsDelegate?.changeEnvironment(currentEnvironment)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func segmentSet(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      currentEnvironment = .Development
    }
    else {
      currentEnvironment = .Laboratory
    }
  }
  
  
}

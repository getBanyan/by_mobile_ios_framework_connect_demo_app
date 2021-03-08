//
//  DashboardViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit
import BanyanService

class DashboardViewController: UIViewController {
  
  @IBOutlet weak var bgColorSegment: UISegmentedControl!
  
  @IBAction func tapToConnectButtonTapped() {
    
    if let userId = UserDefaults.standard.string(forKey: "userId") {
      BYManager.shared.initialize(withId: userId)
    }
    else {
      let randomId = randomString(ofLength: 20)
      BYManager.shared.initialize(withId: randomId)
      UserDefaults.standard.setValue(randomId, forKey: "userId")
    }
    
    BYManager.shared.shouldShowLogs = true
    BYManager.shared.allowsCustomUI = true
    
    if bgColorSegment.selectedSegmentIndex == 1{
      BYManager.shared.setLayoutColor(.blue, forKey: .viewBackgroundColor)
    }
    
    present(BYManager.shared.byNavigationController, animated: true, completion: nil)
  }
  
  func randomString(ofLength length: Int) -> String {
    
    enum randomGenerator {
      static let allowedCharacters = Array("abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789")
      static let k = UInt32(allowedCharacters.count)
    }
    
    var result = [Character](repeating: "-", count: length)
    
    for i in 0 ..< length {
      let randomIndex = Int(arc4random_uniform(randomGenerator.k))
      result[i] = randomGenerator.allowedCharacters[randomIndex]
    }
    
    return String(result)
  }
}

//
//  DashboardViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit
import BYServiceSDK

class DashboardViewController: UIViewController {
  
  var byController: BYController?
  
  @IBOutlet weak var userIdLabel: UILabel!
  @IBOutlet weak var userIdTextField: UITextField!
  
  @IBOutlet weak var customizationView: UIView!
  @IBOutlet weak var viewBgColorSegment: UISegmentedControl!
  @IBOutlet weak var buttonColorSegment: UISegmentedControl!
  @IBOutlet weak var textColorSegment: UISegmentedControl!
  @IBOutlet weak var fontNameSegment: UISegmentedControl!
  @IBOutlet weak var textBoxColorSegment: UISegmentedControl!
  @IBOutlet weak var customAnimationSwitch: UISwitch!
  
  var randomId = ""
  
  let lightGreen = UIColor(red: 4.0/255.0, green: 114.0/255.0, blue: 77.0/255.0, alpha: 1.0)
  let lightPink = UIColor(red: 245.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
  let lightBlue = UIColor(red: 202.0/255.0, green: 216.0/255.0, blue: 222.0/255.0, alpha: 1.0)
  
  let bgColors = [UIColor.white, UIColor.black, UIColor.gray]
  let buttonColors = [UIColor.blue, UIColor.green, UIColor.purple]
  let textColors = [UIColor.orange, UIColor.red, UIColor.yellow]
  var textInputColors: [UIColor]!
  let fontName = ["Ubuntu-Regular", "Antaro"]
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    byController = nil
    textInputColors = [lightGreen, lightPink, lightBlue]
    customizationView.isHidden = customAnimationSwitch.isOn
    customizeSegment()
    setUpTextField()
  }
  
  func customizeSegment() {
    for view in customizationView.subviews {
      if let segmentView = view as? UISegmentedControl {
        segmentView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
      }
    }
  }
  
  func setUpTextField() {
    userIdTextField.layer.borderWidth = 1.0
    userIdTextField.layer.borderColor = UIColor.black.cgColor
    userIdTextField.doneAccessory = true
    
    if let exitingUserId = UserDefaults.standard.string(forKey: "userId") {
      randomId = exitingUserId
    }
    else {
      randomId = randomString(ofLength: 10)
    }
    
    UserDefaults.standard.setValue(randomId, forKey: "userId")
    if let text = userIdLabel.text {
      userIdLabel.text = text + randomId
    }
    
  }
  
  @IBAction func tapToConnectButtonTapped() {
    let userId = getUserId()
    
    byController = BYController(withClientId: userId)
    byController?.shouldShowLogs = true
    byController?.allowsCustomUI = !customAnimationSwitch.isOn
    byController?.setLayoutColor(bgColors[viewBgColorSegment.selectedSegmentIndex], forKey: .viewBackgroundColor)
    byController?.setLayoutColor(buttonColors[buttonColorSegment.selectedSegmentIndex], forKey: .actionColor)
    byController?.setLayoutColor(textColors[textColorSegment.selectedSegmentIndex], forKey: .titleTextColor)
    byController?.setLayoutFontName(fontName[fontNameSegment.selectedSegmentIndex])
    byController?.setLayoutColor(textInputColors[textBoxColorSegment.selectedSegmentIndex], forKey: .inputBackgroundColor)
    byController?.present(on: self, animated: true, completion: nil)
  }
  
  @IBAction func switchChanged(_ sender: UISwitch, forEvent event: UIEvent) {
    customizationView.isHidden = sender.isOn
  }
  
  func getUserId() -> String {
    if let userId = userIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
       userId.count > 0 {
      return userId
    }
    else if let existingUserId = UserDefaults.standard.string(forKey: "userId") {
      return existingUserId
    }
    
    return "Shawn-Frank"
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

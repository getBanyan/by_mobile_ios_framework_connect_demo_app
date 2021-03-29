//
//  DashboardViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit
import BYConnect

class DashboardViewController: UIViewController, SettingsDelegate {
  
  var byConnectController: BYConnectController?
  var currentEnvironment: BYEnvironment = .Laboratory
  
  @IBOutlet weak var userIdTextField: UITextField!
  @IBOutlet weak var apiKeyTextField: UITextField!
  
  @IBOutlet weak var customizationView: UIView!
  @IBOutlet weak var viewBgColorSegment: UISegmentedControl!
  @IBOutlet weak var buttonColorSegment: UISegmentedControl!
  @IBOutlet weak var textColorSegment: UISegmentedControl!
  @IBOutlet weak var fontNameSegment: UISegmentedControl!
  @IBOutlet weak var textBoxColorSegment: UISegmentedControl!
  @IBOutlet weak var customAnimationSwitch: UISwitch!
  
  var randomId = ""
  var randomAPIKey = ""
  
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
    byConnectController = nil
    textInputColors = [lightGreen, lightPink, lightBlue]
    customizationView.isHidden = customAnimationSwitch.isOn
    customizeSegment()
    setUpTextFields()
    setUpNavBar()
  }
  
  func customizeSegment() {
    for view in customizationView.subviews {
      if let segmentView = view as? UISegmentedControl {
        segmentView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
      }
    }
  }
  
  func setUpTextFields() {
    userIdTextField.layer.borderWidth = 1.0
    userIdTextField.layer.borderColor = UIColor.black.cgColor
    userIdTextField.doneAccessory = true
    userIdTextField.attributedPlaceholder = NSAttributedString(string: "Enter a user id or leave blank for a random id",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
    apiKeyTextField.layer.borderWidth = 1.0
    apiKeyTextField.layer.borderColor = UIColor.black.cgColor
    apiKeyTextField.doneAccessory = true
    apiKeyTextField.attributedPlaceholder = NSAttributedString(string: "Enter an api key or leave blank for a random key",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
    if let exitingUserId = UserDefaults.standard.string(forKey: "userId") {
      randomId = exitingUserId
    }
    else {
      randomId = randomString(ofLength: 10)
      UserDefaults.standard.setValue(randomId, forKey: "userId")
    }
    
    if let apiKey = UserDefaults.standard.string(forKey: "apiKey") {
      randomAPIKey = apiKey
    }
    else {
      randomAPIKey = randomString(ofLength: 8)
      UserDefaults.standard.setValue(randomAPIKey, forKey: "apiKey")
    }
  }
  
  func setUpNavBar() {
    //navigationItem.hidesBackButton = true
    //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
  }
  
  @objc
  private func settingsButtonTapped() {
    if let svc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "settingsVC") as? SettingsViewController {
      svc.currentEnvironment = currentEnvironment
      svc.settingsDelegate = self
      present(svc, animated: true, completion: nil)
    }
  }
  
  func changeEnvironment(_ environment: BYEnvironment) {
    currentEnvironment = environment
  }
  
  @IBAction func tapToConnectButtonTapped() {
    let userId = getUserId()
    let apiKey = getAPIKey()
    
    byConnectController = BYConnectController(withClientId: userId, apiKey: apiKey, andEnvironment: .Laboratory)
    byConnectController?.shouldShowLogs = true
    byConnectController?.allowsCustomUI = !customAnimationSwitch.isOn
    byConnectController?.setLayoutColor(bgColors[viewBgColorSegment.selectedSegmentIndex], forKey: .viewBackgroundColor)
    byConnectController?.setLayoutColor(buttonColors[buttonColorSegment.selectedSegmentIndex], forKey: .actionColor)
    byConnectController?.setLayoutColor(textColors[textColorSegment.selectedSegmentIndex], forKey: .titleTextColor)
    byConnectController?.setLayoutFontName(fontName[fontNameSegment.selectedSegmentIndex])
    byConnectController?.setLayoutColor(textInputColors[textBoxColorSegment.selectedSegmentIndex], forKey: .inputBackgroundColor)
    byConnectController?.present(on: self, animated: true, completion: nil)
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
  
  func getAPIKey() -> String {
    if let apiKey = apiKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
       apiKey.count > 0 {
      return apiKey
    }
    else if let existingAPIKey = UserDefaults.standard.string(forKey: "apiKey") {
      return existingAPIKey
    }
    
    return "1234567"
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

//
//  LoginViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit

class LoginViewController: UIViewController {
  
  let kCEOName = ""
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    usernameTextField.layer.borderWidth = 1.0
    passwordTextField.layer.borderWidth = 1.0
    
    usernameTextField.layer.borderColor = UIColor.black.cgColor
    passwordTextField.layer.borderColor = UIColor.black.cgColor
  }
  
  @IBAction func loginButtonTapped() {
    
    activityIndicator.startAnimating()
    activityIndicator.isHidden = false
    
    // simple DispatchQueue used to simulate waiting for a network request's response
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.performLogin()
    }
  }
  
  func performLogin() {
    
    print(UIDevice.current.name)
    if UIDevice.current.name == kCEOName {
      // change the endpoint to production
    }
    let dashboardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "dashboardVC")
    self.activityIndicator.stopAnimating()
    self.navigationController?.pushViewController(dashboardVC, animated: true)
  }
}

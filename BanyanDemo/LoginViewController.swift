//
//  LoginViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginButtonTapped() {
        let moduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moduleVC")
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        // simple DispatchQueue used to simulate waiting for a network request's response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.activityIndicator.stopAnimating()
            self.navigationController?.pushViewController(moduleVC, animated: true)
        }
    }
}

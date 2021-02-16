//
//  DashboardViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBAction func tapToConnectButtonTapped() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC")
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

//
//  DashboardViewController.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBAction func tapToConnectButtonTapped() {
        let moduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moduleVC")
        self.navigationController?.pushViewController(moduleVC, animated: true)
    }
}

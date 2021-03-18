//
//  TransactionTableViewCell.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
  
  static let identifier = "TransactionTableViewCell"
  
  @IBOutlet weak var pk: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var category: UILabel!
  @IBOutlet weak var top_level_category: UILabel!
  @IBOutlet weak var amount: UILabel!
  @IBOutlet weak var transactionDescription: UILabel!
  
  func initializeCell(withTransaction transaction: AWSTransaction) {
    pk.text = transaction.pk
    date.text = transaction.date
    category.text = transaction.category
    top_level_category.text = transaction.top_level_category
    let roundedNumber = round(transaction.amount.floatValue * 100) / 100
    amount.text = "\(transaction.currency_code) \(roundedNumber)"
    transactionDescription.text = transaction.original_description
  }
}

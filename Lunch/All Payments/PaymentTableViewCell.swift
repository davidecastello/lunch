//
//  PaymentTableViewCell.swift
//  Lunch
//
//  Created by Davide Castello on 12/10/2018.
//  Copyright © 2018 Davide Castello. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var payerImageView: UIImageView!
  @IBOutlet weak var tickImageView: UIImageView!
  
  var payment: Payment?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setPayment(payment: Payment) {
    self.payment = payment
    // Date
    paymentLabel.text = payment.dateString()
    // Image
    switch payment.payerEnum() {
    case Payment.Payer.Company:
      payerImageView.image = #imageLiteral(resourceName: "mokuLogo2")
    case Payment.Payer.User:
      payerImageView.image = #imageLiteral(resourceName: "user")
    }
    // Fixed
    self.contentView.alpha = (payment.fixed) ? 0.3 : 1.0
    tickImageView.alpha = (payment.fixed) ? 1.0 : 0.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

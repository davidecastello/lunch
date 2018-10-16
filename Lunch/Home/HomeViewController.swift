//
//  ViewController.swift
//  Lunch
//
//  Created by Davide Castello on 12/10/2018.
//  Copyright © 2018 Davide Castello. All rights reserved.
//

import UIKit
import EXTView
import RealmSwift
import Lottie

class HomeViewController: UIViewController {

  @IBOutlet weak var userView: EXTView!
  @IBOutlet weak var companyView: EXTView!
  @IBOutlet weak var allPaymentsView: EXTView!
  @IBOutlet weak var predictiveLabel: EXTLabel!
  @IBOutlet weak var feedbackView: EXTView!
  @IBOutlet var lotAnimationView: LOTAnimationView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = Constants.appName

    Payment.fixPayments()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    updateView()
  }
  
  func updateView() {
    updatePredictLabel()
  }
  
  func updatePredictLabel() {
    predictiveLabel.text = (Payment.getUserUnfixedPayments().count >= 3)
      ? Constants.companyShouldPay
      : Constants.iShouldPay
  }

  @IBAction func addUserPayment(_ sender: Any) {
    animate(view: userView, completion: {
      Payment.addPayment(payer: Payment.Payer.User)
      self.updateView()
      self.showFeedback()
    })
  }
  
  @IBAction func addCompanyPayment(_ sender: Any) {
    animate(view: companyView, completion: {
      Payment.addPayment(payer: Payment.Payer.Company)
      self.updateView()
      self.showFeedback()
    })
  }
  
  func showFeedback() {
    self.lotAnimationView.setAnimation(named: "simple-tick")
    self.lotAnimationView.animationSpeed = 1
    showFeedbackView(completion: {
      self.lotAnimationView.play(completion: { (finished) in
        self.hideFeedbackView()
      })
    })
  }
  
  func showFeedbackView(completion: (() -> Swift.Void)? = nil) {
    self.feedbackView.isHidden = false
    UIView.transition(with: self.feedbackView, duration: Constants.animationsDuration, options: .transitionCrossDissolve, animations: {
      self.feedbackView.alpha = 1.0
    }) { (Finished) in
      if let _completion = completion {
        _completion()
      }
    }
    self.lotAnimationView.isHidden = false
    UIView.transition(with: self.lotAnimationView, duration: Constants.animationsDuration, options: .transitionCrossDissolve, animations: {
      self.lotAnimationView.alpha = 1.0
    })
  }
  
  func hideFeedbackView() {
    UIView.transition(with: self.feedbackView, duration: Constants.animationsDuration, options: .transitionCrossDissolve, animations: {
      self.feedbackView.alpha = 0.0
    }) { (Finished) in
      self.feedbackView.isHidden = true
    }
    UIView.transition(with: self.lotAnimationView, duration: Constants.animationsDuration, options: .transitionCrossDissolve, animations: {
      self.lotAnimationView.alpha = 0.0
    }) { (Finished) in
      self.lotAnimationView.isHidden = true
    }
  }
  
  @IBAction func goToAllPayments(_ sender: Any) {
    animate(view: allPaymentsView, completion: {
      // Launch PaymentsTableViewController
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if let paymentsController = storyboard.instantiateViewController(withIdentifier: "paymentsTableViewController") as? PaymentsTableViewController {
        self.navigationController?.pushViewController(paymentsController, animated: true)
      }
    })
  }
  
  func animate(view: UIView, completion: (() -> Swift.Void)? = nil) {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
      view.alpha = 0.1
    }) { (Finished) in
      view.alpha = 1.0
      if let _completion = completion {
        _completion()
      }
    }
  }
  
  func restoreDatabase() {
    Payment.deleteAllPayments()
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "03 08 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "06 08 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "10 08 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "27 08 2018"))
    Payment.addPayment(payer: Payment.Payer.Company, date: Payment.dateFromString(string: "30 08 2018"))
    
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "04 09 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "06 09 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "11 09 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "13 09 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "18 09 2018"))
    Payment.addPayment(payer: Payment.Payer.Company, date: Payment.dateFromString(string: "20 09 2018"))
    
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "02 10 2018"))
    Payment.addPayment(payer: Payment.Payer.Company, date: Payment.dateFromString(string: "04 10 2018"))
    
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "09 10 2018"))
    Payment.addPayment(payer: Payment.Payer.User, date: Payment.dateFromString(string: "11 10 2018"))
  }
}

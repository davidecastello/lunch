//
//  Payment.swift
//  Lunch
//
//  Created by Davide Castello on 12/10/2018.
//  Copyright © 2018 Davide Castello. All rights reserved.
//

import Foundation
import RealmSwift

class Payment: Object {
  @objc dynamic var paymentId = ""
  @objc dynamic var date = Date()
  @objc dynamic var payer = 0
  @objc dynamic var fixed = false
  
  override static func primaryKey() -> String? {
    return "paymentId"
  }
  
  static func newPayment(payer: Payer, date: Date? = Date()) -> Payment {
    let payment = Payment()
    payment.date = date!
    payment.payer = payer.rawValue
    payment.paymentId = String(payment.date.timeIntervalSince1970)
    return payment
  }
  
  static func getPayments() -> Results<Payment> {
    let realm = try! Realm()
    return realm.objects(Payment.self)
  }
  
  static func getOrderedPayments() -> Results<Payment> {
    return getPayments().sorted(byKeyPath: "date", ascending: false)
  }
  
  static func getCompanyPayments() -> Results<Payment> {
    return getPayments()
      .sorted(byKeyPath: "date", ascending: true)
      .filter("payer = \(Payer.Company.rawValue)")
  }
  
  static func getUserPayments() -> Results<Payment> {
    return getPayments()
      .sorted(byKeyPath: "date", ascending: true)
      .filter("payer = \(Payer.User.rawValue)")
  }
  
  static func getUserUnfixedPayments() -> Results<Payment> {
    return getUserPayments()
    .filter(NSPredicate(format: "fixed == %@", NSNumber(value: false)))
  }
  
  static func deleteAllPayments() {
    let realm = try! Realm()
    realm.beginWrite()
    realm.deleteAll()
    try! realm.commitWrite()
  }
  
  static func deletePayment(payment: Payment) {
    let realm = try! Realm()
    realm.beginWrite()
    realm.delete(payment)
    _fixPayments()
    try! realm.commitWrite()
  }
  
  enum Payer: Int {
    case User = 0, Company
  }
  
  func payerEnum() -> Payer {
    return Payer(rawValue: self.payer)!
  }
  
  func dateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, d MMM yyyy"
    dateFormatter.locale = Locale.init(identifier: "it_IT")
    return dateFormatter.string(from: date)
  }
  
  static func dateFromString(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    dateFormatter.locale = Locale.init(identifier: "it_IT")
    return dateFormatter.date(from: string)!
  }
  
  static func addPayment(payer: Payer, date: Date? = Date()) {
    let realm = try! Realm()
    realm.beginWrite()
    realm.add(newPayment(payer: payer, date: date), update: true)
    _fixPayments()
    try! realm.commitWrite()
  }
  
  static func fixPayments() {
    let realm = try! Realm()
    realm.beginWrite()
    
    _fixPayments()
    
    try! realm.commitWrite()
  }
  
  // Needs to be called inside a Realm write transaction
  private static func _fixPayments() {
    setFixed(payments: Array(getPayments()), fixed: false)
    
    let companyPayments = getCompanyPayments()
    let userPayments = getUserPayments()
    var i = 0
    for companyPayment in companyPayments {
      // I need at least 3 userPayments
      if (userPayments.count > i + 2) {
        setFixed(payments: [companyPayment, userPayments[i], userPayments[i+1], userPayments[i+2]],
                 fixed: true)
        i = i + 3
      } else {
        break
      }
    }
  }
  
  // Needs to be called inside a Realm write transaction
  private static func setFixed(payments: [Payment], fixed: Bool) {
    for payment in payments {
      payment.fixed = fixed
    }
  }
}

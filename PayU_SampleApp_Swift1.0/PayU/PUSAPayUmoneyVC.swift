//
//  PUSAPayUmoneyVC.swift
//  PayU_SampleApp_Swift1.0
//
//  Created by Saurabh on 25/08/2020.
//  Copyright © 2020 PayU Payments Private Limited. All rights reserved.
//

import Foundation
import UIKit
import PayU_coreSDK_Swift

class PUSAPayUmoneyVC : UIViewController {
  var paymentParams = PayUModelPaymentParams()
  let createRequest = PayUCreateRequest()
  
  @IBAction func btnPayUmoney(_ sender: UIButton) {
    
    
    createRequest.createRequest(withPaymentParam: paymentParams, forPaymentType: PAYMENT_PG_PAYU_MONEY) { (request, error) in
      
      
      let strBrd = UIStoryboard(name: "Main", bundle: nil)
      
      let webViewVC = strBrd.instantiateViewController(withIdentifier: "PUUIWebViewVC") as! PUUIWebViewVC
      
      webViewVC.request = request
      
      self.navigationController?.pushViewController(webViewVC, animated: true)
      
      
      
      
    }
    
    
    
  }
  
  
  
  
  
  
  
  
  
}

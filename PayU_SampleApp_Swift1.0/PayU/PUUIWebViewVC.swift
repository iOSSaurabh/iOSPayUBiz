//
//  PUUIWebViewVC.swift
//  PayU_SampleApp_Swift1.0
//
//  Created by Saurabh on 25/08/2020.
//  Copyright © 2020 PayU Payments Private Limited. All rights reserved.
//

import Foundation
import UIKit
import PayU_coreSDK_Swift
import WebKit


class PUUIWebViewVC : UIViewController,UIWebViewDelegate,WKScriptMessageHandler {
    
    
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var request = NSMutableURLRequest()
  @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var _webView: WKWebView!
    
  
  override func viewDidLoad() {
    
    
 //   self.webView.delegate = self
    
//    webView.loadRequest(request as URLRequest)
    _webView.navigationDelegate = self
    _webView.load(request as URLRequest)
    
    
    
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences

    // Here I am guessing that the Frame of the WebView is the entire Screen
 //   _webView.configuration =   configuration

    configuration.userContentController.add(self, name: "postMessageListener")
    _webView.configuration.userContentController.add(self, name: "observe")
    
    
    activityIndicator.startAnimating()
    
    self.navigationItem.hidesBackButton = true
    let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PUUIWebViewVC.back(sender:)))
    self.navigationItem.leftBarButtonItem = newBackButton
    
  }
  
    @objc func back(sender: UIBarButtonItem) {
    
    
    let alert = UIAlertController(title: "Cancel !", message: "Do you really want to cancel the transaction ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: cancelTransaction))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func cancelTransaction( action : UIAlertAction)
  {
    _ = navigationController?.popToRootViewController(animated: true)
    
  }
    
    func payUSuccessResponse(_ payUResponse: Any!, surlResponse: Any!) {
       // print(surlResponse ?? <#default value#>)
    }
        
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        print(request)
        return true
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        
        let dic = message.body as! [String:Any]
        
        if let response = dic["onPayuSuccess"]{
            
            let strTemp = response as! String
            
            if let data = strTemp.data(using: .utf8) {
                   do {
                       if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                           // Use this dictionary
                           print(dictionary["response"])
                        let temp = dictionary["response"] as! String
                        print(temp)
                        
                        let jsonData = temp.data(using: .utf8)!

                        let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]

                        print(json)
 
                       }
                   } catch _ {
                       // Do nothing
                   }
               }
        }
        
                
        
    }
    
    
    
//
//  func webViewDidFinishLoad(_ webView: UIWebView) {
//
//    activityIndicator.stopAnimating()
//    activityIndicator.isHidden = true
//    let response =  webView.stringByEvaluatingJavaScript(from: "PayU()")
//
//
//    // [webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js waitUntilDone:NO]
//
//
//    //    webView.performSelector(onMainThread: #selector(self.stringByEvaluatingJavaScriptFromString), with: "js", waitUntilDone: false)
//    //    {
//    //
//    //    }
//
//
//    //    if (PayU.status == 1) {
//    //      //success
//    //    } else {
//    //      //failure
//    //    }
//    //
//
//
//
//
//
//
//    if (response != "")
//    {
//
//
//
//      NotificationCenter.default.post(name: Notification.Name("PayUResponse"), object: response)
//
//    }
//
//
//
//  }
  
  
}

extension PUUIWebViewVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        

        webView.evaluateJavaScript("document.documentElement.innerHTML.toString()", completionHandler: { (value: Any!, error: Error!) -> Void in

            if error != nil {
                //Error logic
                return
            }

            //let result = value as? String
            //Main logic
        })
        
       
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        print()
    }
    
    
}


    extension String {
        var htmlDecoded: String {
            let decoded = try? NSAttributedString(data: Data(utf8), options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil).string

            return decoded ?? self
        }
    }


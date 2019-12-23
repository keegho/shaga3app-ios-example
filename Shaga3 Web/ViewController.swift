//
//  ViewController.swift
//  Shaga3 Web
//
//  Created by Kegham Karsian on 10/17/19.
//  Copyright © 2019 Kegham Karsian. All rights reserved.
//  Make sure of privacy camera usage
//  Make sure of privacy microphone usage

import UIKit
import WebKit

class ViewController: UIViewController {
    
    
    
   // let signature = "3f75148a3cc42d2a086118d53b62983ea71b6a92a1091e3525cf483bae26c482" //Get from degla server
   // let sherifSignature = "96482ab7d8ba729c942c30d6b144dd7abd5afd4b13ec03d0e0778f9b1ba03d63"
   // let guestSignature = "e20d6020cf3659c9cce3c738578fc10782aea1ba11612dd78d98a2b44f044f10"
    let key = "degla" //Predefined key

    @IBOutlet weak var webView: WKWebView!
    
    
    override func loadView() {
        
         let webConfiguration = WKWebViewConfiguration()
              // webConfiguration.allowsInlineMediaPlayback = true
               webConfiguration.mediaPlaybackRequiresUserAction = false
        
        webConfiguration.allowsPictureInPictureMediaPlayback = true
               webView = WKWebView(frame: .zero, configuration: webConfiguration)
               webView!.navigationDelegate = self
               webView!.uiDelegate = self
            //WKWebView.clean()
            view = webView
        
//        self.navigationItem.title = "COMPETITION"
//        self.title = "COMPETITION"
//        self.tabBarController?.tabBar.items?[2].title = "COMPETITION"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let config = WKWebViewConfiguration()
//        config.dataDetectorTypes = [.all]
//        webView = WKWebView(frame: .zero, configuration: config)
       // let deglaUser = User(name: "Vahan", uuid: "31531e13fgea") //Degla User
       // let sherifDegla = User(name: "sherif", uuid: "346grs")
        //let guestUser = User(name: "guest", uuid: "guest")
        DispatchQueue.main.async {
        if #available(iOS 13.0, *) {
           
                self.webView.setupActivityIndicator(style: .large, color: .yellow)
                      } else {
                        self.webView.setupActivityIndicator(style: .whiteLarge, color: .yellow)
                  }
            }
       

       // webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
       // webView.configuration.preferences.javaScriptEnabled = true
        //webView.configuration.preferences.plugInsEnabled = true
 
         print(Constants.selectedUser.name)
        let url = URL(string: "https://backend.shaga3app.com/api/authorize?user_name=\(Constants.selectedUser.name)&user_uuid=\(Constants.selectedUser.uuid)")
        
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        
        request.setValue(Constants.selectedUser.signature, forHTTPHeaderField:"x-auth-signature")
        request.setValue(key, forHTTPHeaderField:"x-shaga3app-id")
        webView.load(request)
        print(request)
        print(request.allHTTPHeaderFields)

    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Constants.userValueChanged == true {
            setWebView()
            Constants.userValueChanged = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setWebView), name: .selectedUserChanged, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setWebView() {
       
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                self.webView.setupActivityIndicator(style: .large, color: .yellow)
             } else {
                self.webView.setupActivityIndicator(style: .whiteLarge, color: .yellow)
             }
        }
              

              // webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
              // webView.configuration.preferences.javaScriptEnabled = true
               //webView.configuration.preferences.plugInsEnabled = true
       
               
        let url = URL(string: "https://backend.shaga3app.com/api/authorize?user_name=\(Constants.selectedUser.name)&user_uuid=\(Constants.selectedUser.uuid)")
               
               var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
               
        request.setValue(Constants.selectedUser.signature, forHTTPHeaderField:"x-auth-signature")
               request.setValue(key, forHTTPHeaderField:"x-shaga3app-id")
               webView.load(request)
               print(request)
               print(request.allHTTPHeaderFields)
    }


}



extension ViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.activityIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print(webView.url) //Check redirect after auth
        webView.activityIndicatorView.stopAnimating()
        self.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: message,message: nil,preferredStyle:
        .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {_ in
        completionHandler()})

        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("IM HERE IN CREATEWEBVIEW")
        
        webView.load(navigationAction.request)
        
       // webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // webView.configuration.preferences.plugInsEnabled = true
       //  webView.configuration.preferences.javaScriptEnabled = true
        
        //if navigationAction.targetFrame?.isMainFrame == nil {
       //     UIApplication.shared.open(navigationAction.request.url!)
            
        //    webView.load(navigationAction.request)
      //  }
       // return nil
        
      /*  if navigationAction.targetFrame == nil {
            
            let tempURL = navigationAction.request.url
            var components = URLComponents()
            components.scheme = tempURL?.scheme
            components.host = tempURL?.host
            components.path = tempURL!.path
            
            let webViewTemp = WKWebView(frame: self.webView.bounds, configuration: configuration)
            webViewTemp.uiDelegate = self
            webViewTemp.navigationDelegate = self
            self.view.addSubview(webViewTemp)
            
//            print(tempURL?.path)
//            print(tempURL?.scheme)
//            print(tempURL)
//            print(tempURL?.absoluteString)
            
          //  let newUrl = tempURL?.absoluteString.replacingOccurrences(of: "https://www.facebook.com/", with: "")
         //   print(newUrl ?? "NO URL")
            
         //   UIApplication.shared.canOpenURL(URL(string: "fb://\(newUrl ?? "")")!)
            
        
            
            
           // webViewTemp.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
           // webViewTemp.configuration.preferences.plugInsEnabled = true
          //  webViewTemp.configuration.preferences.javaScriptEnabled = true
            
            return webViewTemp
        }*/
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        self.dismiss(animated: true)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("IM HERE IN DECIDE POLICY FOR ACTION")
        
        
        if let host = navigationAction.request.url?.host {
            if host.contains("facebook.com") || host.contains("whatsapp")  {
                let newUrl = navigationAction.request.url?.absoluteString.replacingOccurrences(of: "https://www.facebook.com/", with: "")
                print(newUrl ?? "NO URL")
                //UIApplication.shared.open(URL(string: "fb://\(newUrl ?? "")")!)
               // UIApplication.shared.canOpenURL(navigationAction.request.url!)
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            } //else if host.contains("shaga3app.com") {
            //    decisionHandler(.allow)
           // }
        }

        decisionHandler(.allow)
       // self.dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("IM HERE IN DECIDE POLICY FOR RESPONSE")
        decisionHandler(.allow)
    }
}


extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}

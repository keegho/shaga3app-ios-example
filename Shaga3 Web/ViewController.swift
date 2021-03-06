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
    
    
    
   // let signature = "3f75148a3cc42d2a086118d53b62983ea71b6a92a1091e3525cf483bae26c482" //Get from server usin HMAC
    
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

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let config = WKWebViewConfiguration()
        config.dataDetectorTypes = [.all]
        webView = WKWebView(frame: .zero, configuration: config)
        let deglaUser = User(name: "Vahan", uuid: "31531e13fgea") //Degla User
        let sherifDegla = User(name: "sherif", uuid: "346grs")
        let guestUser = User(name: "guest", uuid: "guest")
        */
        
        setWebView()

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

       
           print(Constants.selectedUser.name)
        let url = URL(string: "https://backend.shaga3app.com/api/authorize?user_name=\(Constants.selectedUser.name)&user_uuid=\(Constants.selectedUser.uuid)")
               
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
               
        request.setValue(Constants.selectedUser.signature, forHTTPHeaderField:"x-auth-signature")
               request.setValue(key, forHTTPHeaderField:"x-shaga3app-id")
               webView.load(request)
              
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
        
        //Check redirect after auth
        print(webView.url?.absoluteString)
        webView.activityIndicatorView.stopAnimating()
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

        webView.load(navigationAction.request)
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        self.dismiss(animated: true)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
            if (navigationAction.request.url?.absoluteString.contains("www"))! {//if host.contains("apple")  {
                if let url = navigationAction.request.url {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Earlier versions
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }

                decisionHandler(.cancel)
                return
            }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

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

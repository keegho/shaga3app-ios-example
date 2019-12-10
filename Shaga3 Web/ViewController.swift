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
    
    let signature = "3f75148a3cc42d2a086118d53b62983ea71b6a92a1091e3525cf483bae26c482" //Get from degla server
    let signatureSherif = "96482ab7d8ba729c942c30d6b144dd7abd5afd4b13ec03d0e0778f9b1ba03d63"
    let key = "degla" //Predefined key

    @IBOutlet weak var webView: WKWebView!
    
    
    override func loadView() {
         let webConfiguration = WKWebViewConfiguration()
              // webConfiguration.allowsInlineMediaPlayback = true
               webConfiguration.mediaPlaybackRequiresUserAction = false
               webView = WKWebView(frame: .zero, configuration: webConfiguration)
               webView!.navigationDelegate = self
               webView!.uiDelegate = self
            view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let config = WKWebViewConfiguration()
//        config.dataDetectorTypes = [.all]
//        webView = WKWebView(frame: .zero, configuration: config)
        
        
        let deglaUser = User(name: "Vahan", uuid: "31531e13fgea") //Degla User
        let sherifDegla = User(name: "sherif", uuid: "346grs")
       
        if #available(iOS 13.0, *) {
                          webView.setupActivityIndicator(style: .large, color: .yellow)
                      } else {
                          webView.setupActivityIndicator(style: .whiteLarge, color: .yellow)
                      }
       
        
       // webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
       // webView.configuration.preferences.javaScriptEnabled = true
        //webView.configuration.preferences.plugInsEnabled = true
 
        
        let url = URL(string: "https://backend.shaga3app.com/api/authorize?user_name=\(sherifDegla.name)&user_uuid=\(sherifDegla.uuid)")
        
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        
        request.setValue(signatureSherif, forHTTPHeaderField:"x-auth-signature")
        request.setValue(key, forHTTPHeaderField:"x-shaga3app-id")
        webView.load(request)
        print(request)
        print(request.allHTTPHeaderFields)

    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}



extension ViewController: WKUIDelegate, WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.activityIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print(webView.url) //Check redirect after auth
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
        print("IM HERE IN CREATEWEBVIEW")
       // webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // webView.configuration.preferences.plugInsEnabled = true
       //  webView.configuration.preferences.javaScriptEnabled = true
        
        //if navigationAction.targetFrame?.isMainFrame == nil {
       //     UIApplication.shared.open(navigationAction.request.url!)
            
        //    webView.load(navigationAction.request)
      //  }
       // return nil
        
        if navigationAction.targetFrame == nil {
            
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
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        self.dismiss(animated: true)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("IM HERE IN DECIDE POLICY FOR")
        
        
        if let host = navigationAction.request.url?.host {
            if host.contains("facebook.com") || host.contains("whatsapp")  {
                let newUrl = navigationAction.request.url?.absoluteString.replacingOccurrences(of: "https://www.facebook.com/", with: "")
                print(newUrl ?? "NO URL")
               // UIApplication.shared.open(URL(string: "fb://\(newUrl ?? "")")!)
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
}

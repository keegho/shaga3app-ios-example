//
//  UIViewExt.swift
//  Shaga3 Web
//
//  Created by Kegham Karsian on 10/17/19.
//  Copyright © 2019 Kegham Karsian. All rights reserved.
//

import Foundation
import UIKit

fileprivate var kActivityIndicatorViewAssociativeKey = "kActivityIndicatorViewAssociativeKey"

extension UIView {
    
    
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            guard let activityIndicatorView = getAssociatedObject(&kActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView else {
                
                //let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: -40, width: 40, height: 40))
                let activityIndicatorView = UIActivityIndicatorView(frame: self.bounds)
                activityIndicatorView.style = .gray
                activityIndicatorView.color = .gray
                activityIndicatorView.center = center
                //activityIndicatorView.frame.y = activityIndicatorView.frame.y - 40
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                setAssociatedObject(activityIndicatorView, associativeKey: &kActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                activityIndicatorView.bringSubviewToFront(self)
                return activityIndicatorView
            }
            activityIndicatorView.bringSubviewToFront(self)
            return activityIndicatorView
        }
        
        set {
            addSubview(newValue)
            setAssociatedObject(newValue, associativeKey:&kActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupActivityIndicator(style: UIActivityIndicatorView.Style, color: UIColor) {
        activityIndicatorView.style = style
        activityIndicatorView.color = color
    }
}


// MARK: - Methods
public extension NSObject {
    func setAssociatedObject<T>(_ value: T?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let valueAsAnyObject = value {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any? {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey) else {
            return nil
        }
        return valueAsType
    }
}

extension Notification.Name {
    static let selectedUserChanged = Notification.Name("on-selected-user-change")
}


extension UIViewController {
  func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
  }
}

//
//  UIViewController+Extension.swift
//  Aadhaar Service
//
//  Created by Rohan Kumar on 06/08/26.
//
internal import UIKit

extension UIViewController{
    /// Simple OK Alert
    func showAlert(
        title: String = "Alert",
        message: String,
        buttonTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
                completion?()
            }
            
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

//
//  Controller+Extension.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 11/05/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message:String) {
        let alertViewController = UIAlertController(title:"Message", message:message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title:"Ok", style: UIAlertAction.Style.cancel, handler: { (alert) in
            alertViewController.dismiss(animated:true, completion:nil)
        })
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated:true, completion:nil)
    }
}

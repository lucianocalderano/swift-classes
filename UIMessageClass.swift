//
//  UIMessageClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 15/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import MessageUI

class UIMessageClass: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    var mainCtrl = UIApplication.shared.keyWindow?.rootViewController
    class func setMainViewController (mainViewCtrl: UIViewController) {
        UIMessageClass().setMainViewController(mainViewCtrl: mainViewCtrl)
    }
    class func sendSMS (to: String) {
        UIMessageClass().sendSMS(to: to)
    }
    class func openCall (to: String) {
        UIMessageClass().openCall(to: to)
    }
    class func openVideoCall (to: String) {
        UIMessageClass().openVideoCall(to: to)
    }
    class func sendEmail (to: String) {
        UIMessageClass().sendEmail(to: to)
    }
    
    private func setMainViewController (mainViewCtrl: UIViewController) {
        self.mainCtrl = mainViewCtrl
    }
    private func sendSMS (to: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [to]
            controller.messageComposeDelegate = self
            self.mainCtrl?.present(controller, animated: true, completion: nil)
        }
    }
    
    private func openCall (to: String) {
        let s = "telprompt://" + to
        UIApplication.shared.openURL(URL.init(string: s)!)
    }
    private func openVideoCall (to: String) {
        let s = "facetime://" + to
        UIApplication.shared.openURL(URL.init(string: s)!)
    }
    private func sendEmail (to: String) {
        let controller = MFMailComposeViewController()
        
        controller.mailComposeDelegate = self
        
        controller.setSubject("")
        controller.setToRecipients([to])
        controller.setMessageBody("", isHTML: false)
        
        self.mainCtrl?.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var response = ""
        switch result {
        case .cancelled:
            response = "Message cancelled"
        case .failed:
            response = "Message failed"
        case .sent:
            response = "Message sent"
        }
        print(response)
        self.mainCtrl?.showAlert(response, message: "", okBlock: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var response = ""
        switch result {
        case .cancelled:
            response = "Message cancelled"
        case .failed:
            response = "Message failed"
        case .sent:
            response = "Message sent"
        default:
            response = "Message error: " + (error?.localizedDescription)!
        }
        print(response)
        self.mainCtrl?.showAlert(response, message: "", okBlock: nil)
    }
    
}

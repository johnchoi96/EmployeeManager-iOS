//
//  AboutViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 6/8/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class AboutViewController: UIViewController {

    @IBOutlet weak var currentUserTitleLabel: UILabel!
    @IBOutlet weak var appVersionTitleLabel: UILabel!
    @IBOutlet weak var buildNumberTitleLabel: UILabel!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buildNumberLabel: UILabel!
    @IBOutlet weak var osLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    
    @IBOutlet weak var devWebsiteButton: UIButton!
    
    var userEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyLocalization()
        
        devWebsiteButton.layer.cornerRadius = 15
        
        appVersionLabel.text = K.APP_VERSION
        buildNumberLabel.text = K.BUILD_NUMBER
        osLabel.text = K.OS
        currentUserLabel.text = userEmail + "   "
    }
    
    private func applyLocalization() {
        appVersionTitleLabel.text = NSLocalizedString("app version label", comment: "Short app version label")
        buildNumberTitleLabel.text = NSLocalizedString("build number label", comment: "Build number")
        currentUserTitleLabel.text = NSLocalizedString("current user label", comment: "Current user")
    }

    @IBAction func devWebsitePressed(_ sender: UIButton) {
        let address = "https://johnchoi96.github.io/"
        guard let url = URL(string: address) else {
            let alert = UIAlertController(title: NSLocalizedString("cannot load page alert", comment: ""), message: NSLocalizedString("cannot load page alert message", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("Close message", comment: ""), style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        self.present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func actionBarButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        let feedbackAction = UIAlertAction(title: "Send Feedback", style: .default) { (action) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["johnchoi1003@icloud.com"])
                mail.setSubject("Employee Manager - iOS Feedback from \(self.userEmail!)")
                mail.setMessageBody(K.FEEDBACK_HTML(email: self.userEmail!), isHTML: true)
                
                self.present(mail, animated: true)
            } else {
                let alert = UIAlertController(title: "Cannot send feedback", message: "Problem occured while trying to open email screen.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Close", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        let bugReportAction = UIAlertAction(title: "Report Bug", style: .default) { (action) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["johnchoi1003@icloud.com"])
                mail.setSubject("Employee Manager - iOS Bug Report from \(self.userEmail!)")
                mail.setMessageBody(K.BUG_REPORT_HTML(email: self.userEmail!), isHTML: true)
                
                self.present(mail, animated: true)
            } else {
                let alert = UIAlertController(title: "Cannot send bug report", message: "Problem occured while trying to open email screen.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Close", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        let changeLanguageAction = UIAlertAction(title: "Change app language", style: .default) { (action) in
            let alert = UIAlertController(title: "Choose language", message: "This will require app restart", preferredStyle: .actionSheet)
            let enAction = UIAlertAction(title: "English", style: .default) { (action) in
                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                self.confirmAppRestart(sender)
            }
            let koAction = UIAlertAction(title: "Korean", style: .default) { (action) in
                UserDefaults.standard.set(["ko"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                self.confirmAppRestart(sender)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(enAction)
            alert.addAction(koAction)
            alert.addAction(cancelAction)
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = sender
            }
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(feedbackAction)
        alert.addAction(bugReportAction)
        print(UIDevice.current.model)
        if UIDevice.current.model == "iPad" {
            alert.addAction(changeLanguageAction)
        }
        alert.addAction(cancelAction)
        // present as popover on iPads
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Asks the user for a app termination confirmation and terminates the app.
     NOTE: using exit(Int32) is not permitted by Apple and will be rejected from the App Store. 
     */
    private func confirmAppRestart(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure you want to change language?", message: "App will restart", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Restart", style: .destructive) { (action) in
            // quit app
            // UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil) // this only puts the app to background
            exit(0)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: MFMailComposeViewControllerDelegate section
extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//
//  AboutViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 6/8/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController {

    @IBOutlet weak var appVersionTitleLabel: UILabel!
    @IBOutlet weak var buildNumberTitleLabel: UILabel!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buildNumberLabel: UILabel!
    @IBOutlet weak var osLabel: UILabel!
    
    @IBOutlet weak var devWebsiteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyLocalization()
        
        devWebsiteButton.layer.cornerRadius = 15
        
        appVersionLabel.text = K.APP_VERSION
        buildNumberLabel.text = K.BUILD_NUMBER
        osLabel.text = K.OS
    }
    
    private func applyLocalization() {
        appVersionTitleLabel.text = NSLocalizedString("app version label", comment: "Short app version label")
        buildNumberTitleLabel.text = NSLocalizedString("build number label", comment: "Build number")
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
}

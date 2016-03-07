//
//  InformationsQR.swift
//  Shaqr
//
//  Created by Valentin Martin on 18/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import Foundation
import UIKit

class InformationsQR: UIViewController {
    
    @IBOutlet weak var InfoLabel: UILabel!
    
    override func viewDidLoad() {
        let objectClassName = detailsQRCode.sharedInstance
        self.InfoLabel.text = objectClassName.contentQR
        let searchURL : NSURL = NSURL(string: objectClassName.contentQR!)!
        print(searchURL)
        UIApplication.sharedApplication().openURL(searchURL)
    }
}
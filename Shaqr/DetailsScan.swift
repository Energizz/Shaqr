//
//  DetailsScan.swift
//  Shaqr
//
//  Created by Valentin Martin on 26/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import Foundation
import UIKit

class DetailsScan: UIViewController {
    var data:AnyObject?
    @IBOutlet weak var TextView: UITextView!
    override func viewDidLoad() {
        print(data?.stringValue)
        TextView.text = self.data?.stringValue
    }
}

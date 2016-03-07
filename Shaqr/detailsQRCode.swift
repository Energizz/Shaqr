//
//  detailsQRCode.swift
//  Shaqr
//
//  Created by Valentin Martin on 18/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import Foundation

class detailsQRCode {
    static let sharedInstance = detailsQRCode()
    var contentQR:String?
    
    private init() {
    }
    
    func setContentQR(content:String) {
        self.contentQR = content
    }
}

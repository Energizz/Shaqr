//
//  QRCodeGen.swift
//  Shaqr
//
//  Created by Valentin Martin on 05/03/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import Foundation
import UIKit

class QRCodeGen : UIViewController {
    var qrcodeImage: CIImage!
    @IBOutlet weak var imgQRCode: UIImageView!
    var url : String = ""
    override func viewDidLoad() {
        let data = self.url.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter!.outputImage
        imgQRCode.image = UIImage(CIImage: qrcodeImage)
    }
}

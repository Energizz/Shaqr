//
//  ShareViewController.swift
//  Partager avec Shaqr
//
//  Created by Valentin Martin on 19/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import UIKit
import Contacts

class ShareViewController: UIViewController {
    var shareUrl : String = ""
    var qrcodeImage: CIImage!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    override func viewDidLoad() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") == true {
                    itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (url, error) -> Void in
                        print(url)
                        if let shareURL = url as? NSURL {
                            dispatch_async(dispatch_get_main_queue(), {
                                let data = shareURL.absoluteString.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
                                
                                let filter = CIFilter(name: "CIQRCodeGenerator")
                                
                                filter!.setValue(data, forKey: "inputMessage")
                                filter!.setValue("Q", forKey: "inputCorrectionLevel")
                                
                                self.qrcodeImage = filter!.outputImage
                                self.imgQRCode.image = UIImage(CIImage: self.qrcodeImage)
                                self.imgQRCode.tintColor = UIColor.orangeColor() // CHANGE COLOR QRCODE
                            })
                        }
                    })
                }
                else if itemProvider.hasItemConformingToTypeIdentifier("public.vcard") == true {
                    itemProvider.loadItemForTypeIdentifier("public.vcard", options: nil) { item, error in
                        if error == nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                if let data = item as? NSData, let vCardString = String(data: data, encoding: NSUTF8StringEncoding) {
                                    var myStringArr = vCardString.componentsSeparatedByString("PHOTO")
                                    let data = myStringArr[0].dataUsingEncoding(NSUTF8StringEncoding)
                                    let filter = CIFilter(name: "CIQRCodeGenerator")
                                    
                                    filter!.setValue(data, forKey: "inputMessage")
                                    filter!.setValue("Q", forKey: "inputCorrectionLevel")
                                    
                                    self.qrcodeImage = filter!.outputImage
                                    self.imgQRCode.image = UIImage(CIImage: self.qrcodeImage)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.extensionContext?.completeRequestReturningItems([], completionHandler:nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

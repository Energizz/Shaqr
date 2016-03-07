//
//  CameQRCode.swift
//  Shaqr
//
//  Created by Valentin Martin on 20/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Contacts

class CameQRCode: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var pageController: UIPageViewController!
    var input:AnyObject?
    var data: AnyObject?
    @IBOutlet weak var NavigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //let error:NSError?
        do {
            self.input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
        }  catch let error as NSError {
            print(error)
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(self.input as! AVCaptureInput)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.redColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(NavigationBar!)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            let svc = segue.destinationViewController as! DetailsScan;
            svc.data = self.data
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            captureSession?.stopRunning()
            if metadataObj.stringValue != nil {
                if verifyUrl(metadataObj.stringValue) == true {
                    let searchURL : NSURL = NSURL(string: metadataObj.stringValue)!
                    UIApplication.sharedApplication().openURL(searchURL)
                } else {
                    //let datatest = metadataObj.stringValue.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    //let datatest = metadataObj.stringValue as NSDictionary
                    //let convertedStr = NSDictionary(object: datatest!, forKey: NSUTF8StringEncoding)
                    //try! print(NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(datatest!))
                    /*if let array = NSKeyedUnarchiver.unarchiveObjectWithData(datatest!) as? NSArray {
                        let objects = NSMutableArray(array: array)
                        print(objects[0])
                    }*/
                    let contact = CNMutableContact()
                    
                    contact.imageData = NSData() // The profile picture as a NSData object
                    
                    contact.givenName = "John"
                    contact.familyName = "Appleseed"
                    
                    let homeEmail = CNLabeledValue(label:CNLabelHome, value:"john@example.com")
                    let workEmail = CNLabeledValue(label:CNLabelWork, value:"j.appleseed@icloud.com")
                    contact.emailAddresses = [homeEmail, workEmail]
                    
                    contact.phoneNumbers = [CNLabeledValue(
                        label:CNLabelPhoneNumberiPhone,
                        value:CNPhoneNumber(stringValue:"(408) 555-0126"))]
                    
                    let homeAddress = CNMutablePostalAddress()
                    homeAddress.street = "1 Infinite Loop"
                    homeAddress.city = "Cupertino"
                    homeAddress.state = "CA"
                    homeAddress.postalCode = "95014"
                    contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
                    
                    let birthday = NSDateComponents()
                    birthday.day = 1
                    birthday.month = 4
                    birthday.year = 1988  // You can omit the year value for a yearless birthday
                    contact.birthday = birthday
                    
                    // Saving the newly created contact
                    let store = CNContactStore()
                    let saveRequest = CNSaveRequest()
                    saveRequest.addContact(contact, toContainerWithIdentifier:nil)
                    try! store.executeSaveRequest(saveRequest)
                }
            }
        }
    }
}
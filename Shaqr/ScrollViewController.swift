//
//  ScrollViewController.swift
//  Shaqr
//
//  Created by Valentin Martin on 20/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    /* Var */
    
    @IBOutlet weak var imageView: UIImageView!
    var pageIndex: Int!
    var imageFile: String!
    
    /* ViewDid... */
    
    override func viewDidLoad() {
        self.imageView.image = UIImage(named: self.imageFile)
    }
    
    /* Funcs */
    
    
    
    /* ACTION FROM STORYBOARD */
}

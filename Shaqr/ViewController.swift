//
//  ViewController.swift
//  Shaqr
//
//  Created by Valentin Martin on 18/02/16.
//  Copyright © 2016 Valentin Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    var pageController: UIPageViewController!
    var pageTitles: NSArray! = []
    var pageImages: NSArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "Slide 1 ", "Slide 2")
        self.pageImages = NSArray(objects: "slide_1", "slide_2")
        self.pageController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as ScrollViewController
        let viewControllers = NSArray(object: startVC)
        self.pageController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.pageController.view.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height - 170)
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index: Int) -> ScrollViewController {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return ScrollViewController()
        }
        let vc: ScrollViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ScrollViewController") as! ScrollViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScrollViewController
        var index = vc.pageIndex as Int
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScrollViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound) {
            return nil
        }
        index++
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


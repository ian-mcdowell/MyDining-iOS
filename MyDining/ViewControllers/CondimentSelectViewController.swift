//
//  CondimentSelectViewController.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class CondimentSelectViewController: RKSwipeBetweenViewControllers {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerArray.addObject(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as UIViewController)
        self.viewControllerArray.addObject(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as UIViewController)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

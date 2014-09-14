//
//  CondimentsPickerViewController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class CondimentsPickerViewController: UIViewController, TTSlidingPagesDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfPagesForSlidingPagesViewController(source: TTScrollSlidingPagesController!) -> Int32 {
        return 3
    }
    
    func pageForSlidingPagesViewController(source: TTScrollSlidingPagesController!, atIndex index: Int32) -> TTSlidingPage! {
        var viewController = UIViewController()
        return TTSlidingPage(contentViewController: viewController);
        //UIViewController *viewController = [[UIViewController alloc] init];
        //return [[TTSlidingPage alloc] initWithContentViewController:viewController];
    }
    
    func titleForSlidingPagesViewController(source: TTScrollSlidingPagesController!, atIndex index: Int32) -> TTSlidingPageTitle! {
        var title = TTSlidingPageTitle(headerText: "Page");
        return title;
        
        
        /*TTSlidingPageTitle *title;
        if (index == 0){ //for the first page, have an image, for all other pages use text
        //use a image as the header for the first page
        title= [[TTSlidingPageTitle alloc] initWithHeaderImage:[UIImage imageNamed:@"randomImage.png"]];
        } else {
        //all other pages just use a simple text header
        title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"A page"]; //in reality you would have the correct header text for your page number given by "index"
        }
        return title;*/
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

//
//  CondimentsPickerViewController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class CondimentsPickerViewController: UIViewController, TTSlidingPagesDataSource, UITableViewDataSource, UITableViewDelegate {
    var condimentGroups: Array<CondimentGroup>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var slider = TTScrollSlidingPagesController()
        slider.titleScrollerBackgroundColour = UIColor(red: 196/255, green: 0/255, blue: 0/255, alpha: 0.8);
        slider.dataSource = self
        slider.view.frame = self.view.frame
        self.view.addSubview(slider.view)
        self.addChildViewController(slider)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfPagesForSlidingPagesViewController(source: TTScrollSlidingPagesController!) -> Int32 {
        return Int32(self.condimentGroups.count)
    }
    
    func pageForSlidingPagesViewController(source: TTScrollSlidingPagesController!, atIndex index: Int32) -> TTSlidingPage! {
        var tableViewController = UITableViewController()
        
        tableViewController.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableViewController.tableView.delegate = self
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.tag = Int(index);
        tableViewController.tableView.allowsMultipleSelection = true;
        
        var slidingPage = TTSlidingPage(contentViewController: tableViewController);
        
        tableViewController.tableView.frame = slidingPage.contentView.frame
        
        return slidingPage;
        //UIViewController *viewController = [[UIViewController alloc] init];
        //return [[TTSlidingPage alloc] initWithContentViewController:viewController];
    }
    
    func titleForSlidingPagesViewController(source: TTScrollSlidingPagesController!, atIndex index: Int32) -> TTSlidingPageTitle! {
        var condimentGroup = self.condimentGroups[Int(index)]
        var title = TTSlidingPageTitle(headerText: condimentGroup.name);
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        var group = tableView.tag
        var condiment = self.condimentGroups[group].condiments[indexPath.item]
        
        cell.textLabel!.text = condiment.name
        
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var group = tableView.tag
        return self.condimentGroups[group].condiments.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = UITableViewCellAccessoryType.None
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

//
//  OrderProcessedController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/14/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class OrderProcessedController: UIViewController {
    
    @IBOutlet var processingNumber: UILabel!
    @IBOutlet var pickupTime: UILabel!
    @IBOutlet var location: UILabel!
    var number: String!
    var time: NSDate!
    var pickupLocation: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.processingNumber.text = "Processing Number: \(number)"
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm aa"
        var pTime = formatter.stringFromDate(time)
        self.pickupTime.text = "Pickup Time: \(pTime)"

        self.location.text = "Pickup Location: \(pickupLocation)"

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

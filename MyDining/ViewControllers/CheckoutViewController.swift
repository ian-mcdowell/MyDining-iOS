//
//  CheckOutViewController.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class CheckOutViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var timePicker: UIDatePicker!
    
    var loadedDate: NSDate?
    
    var cart: Cart!
    
    var payment = ["Candy", "food", "sleep"];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self;
        
        self.loadAvailableDates()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func processOrder(sender: AnyObject){
        self.performSegueWithIdentifier("orderComplete", sender: self)

    }
    
    // MARK : Loading shit
    func loadAvailableDates() {
        var uniqueID = (UIApplication.sharedApplication().delegate as AppDelegate).configuration["ouniq"];
        var auth = (UIApplication.sharedApplication().delegate as AppDelegate).account!.authID
        var item = cart.items[0]
        
        var url = "\(Utils.getBaseURL())/qp.dca?nmout=1&dx=12345678"
        var params = "oGetAvailableDates~\(uniqueID!)~\(auth)~\(item.location.id)~0~~0"
        Networking.post(url, data: params) { (data, error) -> Void in
            if (error != nil) {
                NSLog("Error loading available dates: \(error?.localizedDescription)")
                return
            }
            if (data!.rangeOfString("410|OK|") == nil) {
                self.showErrorLoading()
                return;
            }
            NSLog(data!)
            var days = (data! as NSString).stringByReplacingOccurrencesOfString("410|OK|", withString: "");
            
            var daysArray = days.componentsSeparatedByString("|");
            var day = (daysArray[1] as NSString).substringFromIndex(1);
            
            var comps = NSDateComponents()
            comps.year = ((day as NSString).substringWithRange(NSMakeRange(0, 4)) as String).toInt()!
            comps.month = ((day as NSString).substringWithRange(NSMakeRange(4, 2)) as String).toInt()!
            comps.day = ((day as NSString).substringWithRange(NSMakeRange(6, 2)) as String).toInt()!
            self.loadedDate = NSCalendar.currentCalendar().dateFromComponents(comps)
            
            self.loadAvailableTimes()
        }
    }
    
    func loadAvailableTimes() {
        var uniqueID = (UIApplication.sharedApplication().delegate as AppDelegate).configuration["ouniq"];
        var auth = (UIApplication.sharedApplication().delegate as AppDelegate).account!.authID
        var item = cart.items[0]
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        var dateString = formatter.stringFromDate(self.loadedDate!)
        
        var url = "\(Utils.getBaseURL())/qp.dca?nmout=1&dx=12345678"
        var params = "oGetTimeSlots~\(uniqueID!)~\(auth)~\(item.location.id)~0~\(dateString)~~0";
        Networking.post(url, data: params) { (data, error) -> Void in
            if (error != nil) {
                NSLog("Error loading available dates: \(error?.localizedDescription)")
                return
            }
            if (data!.rangeOfString("420|OK|") == nil) {
                self.showErrorLoading()
                return;
            }
            NSLog(data!)
            var times = (data! as NSString).stringByReplacingOccurrencesOfString("420|OK|", withString: "");
            
            var timesArray = times.componentsSeparatedByString("|");
            var firstTime = (timesArray[1] as NSString).substringFromIndex(1);
            
            var firstComps = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit, fromDate: self.loadedDate!)
            firstComps.hour = ((firstTime as NSString).substringWithRange(NSMakeRange(0, 2)) as String).toInt()!
            firstComps.minute = ((firstTime as NSString).substringWithRange(NSMakeRange(2, 2)) as String).toInt()!
            
            var startDate = NSCalendar.currentCalendar().dateFromComponents(firstComps)
            self.timePicker.minimumDate = startDate
            
            var lastTime = (timesArray[timesArray.count - 1] as NSString).substringFromIndex(1);
            
            var lastComps = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit, fromDate: self.loadedDate!)
            lastComps.hour = ((lastTime as NSString).substringWithRange(NSMakeRange(0, 2)) as String).toInt()!
            lastComps.minute = ((lastTime as NSString).substringWithRange(NSMakeRange(2, 2)) as String).toInt()!
            
            var endDate = NSCalendar.currentCalendar().dateFromComponents(lastComps)
            self.timePicker.maximumDate = endDate
            
           // self.cart.items[0].date = day;
            
            self.loadPaymentMethods()
        }
    }
    
    func loadPaymentMethods() {
        
    }
    
    func showErrorLoading() {
        var alert = UIAlertView(title: "Error", message: "Failed to load vital information... :(", delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.payment.count;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.payment[row];
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
//
//  CheckOutViewController.swift
//  MyDining
//
//  Created by Mac Liu on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class CheckOutViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var timePicker: UIDatePicker!
    
    var payment = ["Candy", "food", "sleep"];
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.delegate = self;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

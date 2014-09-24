//
//  ItemSummaryViewController.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

class ItemSummaryViewController: UITableViewController, CondimentsPickerDelegate {

    var order: Order!
    var appDelegate: AppDelegate!
    var valid = false;
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var itemInfo: UILabel!
    @IBOutlet var itemCost: UILabel!
    @IBOutlet var studentsName: UITextField!
    @IBOutlet var specialRequests: UITextField!
    @IBOutlet var condimentRowTitle: UILabel!
    @IBOutlet var condimentDetailView: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        self.itemName.text = order.item.name
        self.itemInfo.text = order.item.info;
        self.itemCost.text = NSString(format: "Price: $%.02f",self.order.item.cost)
        
        self.imageView.image = nil;
        
        if (self.order.item.condimentGroups.count == 0) {
            self.condimentRowTitle.textColor = UIColor(white: 0.7, alpha: 1.0);
            self.condimentDetailView.textColor = UIColor(white: 0.7, alpha: 1.0);
            self.condimentDetailView.text = "None";
            self.valid = true;
        } else {
            self.updateDetailView()
        }
        
        self.loadImage();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true)
    }
    
    func setCondiments(condiments: Array<Condiment>, valid: Bool) {
        self.order.condiments = condiments;
        self.valid = valid;
        self.updateDetailView()
    }
    
    func updateDetailView() {
        if (self.order.condiments.count > 0) {
            var condimentsString = "";
            for (var i = 0; i < self.order.condiments.count; i++) {
                if (i != 0) {
                    condimentsString += ", "
                }
                condimentsString += self.order.condiments[i].name
            }
            self.condimentDetailView.text = condimentsString
            self.condimentDetailView.textColor = UIColor.lightGrayColor()
        } else {
            self.condimentDetailView.text = "None selected"
            self.condimentDetailView.textColor = UIColor.redColor()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func addToCart(sender: AnyObject) {
        if (!self.valid) {
            var alert = UIAlertView(title: "Invalid order", message: "Make sure you have selected the correct options for your order.", delegate: self, cancelButtonTitle: "Okay")
            alert.show();
            return;
        }
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if (appDelegate.cart.location != nil && (appDelegate.cart.location!.id != order.location.id)) {
            var alert = UIAlertView(title: "Woops!", message: "You can only add items to the cart from the same location.", delegate: self, cancelButtonTitle: "Oh gotcha.");
            alert.show();
            return;
        }
        
        // add info user enterred
        self.order.name = self.studentsName.text;
        self.order.specialRequests = self.specialRequests.text;
        
        
        appDelegate.cart.items.append(self.order);
        appDelegate.cart.location = order.location
        
        self.cancel(sender);
    }
    
    func loadImage() {
        
        var pre = appDelegate.configuration["uplImagePre"]!
        var url = "\(pre)\(self.order.item.imageName).png";
        Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.URL).response { (request, response, data, error) -> Void in
        if (error != nil) {
        NSLog("Failed to load image at url \(url)")
        self.imageView.image = nil
        return;
        }
        var image = UIImage(data: data as NSData)
        self.imageView.image = image
        self.imageView.alpha = 0.0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imageView.alpha = 1.0
        })
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if (indexPath.item == 1) {
            if (self.order.item.condimentGroups.count > 0) {
                return indexPath
            }
        }
        return nil
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editCondiments") {
            var destinationViewController = segue.destinationViewController as CondimentsPickerViewController
            destinationViewController.delegate = self;
            destinationViewController.condimentGroups = self.order.item.condimentGroups
        }
    }
    

}

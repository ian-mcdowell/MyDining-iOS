//
//  ItemSummaryViewController.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

class ItemSummaryViewController: UITableViewController {

    var order: Order!
    var appDelegate: AppDelegate!
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var itemInfo: UILabel!
    @IBOutlet var itemCost: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        self.itemName.text = order.item.name
        self.itemInfo.text = order.item.info;
        self.itemCost.text = NSString(format: "Price: $%.02f",self.order.item.cost)
        
        self.imageView.image = nil;
        
        self.loadImage();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func addToCart(sender: AnyObject) {
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.cart.items.append(self.order);
        
        self.cancel(sender);
    }
    
    func loadImage(){
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

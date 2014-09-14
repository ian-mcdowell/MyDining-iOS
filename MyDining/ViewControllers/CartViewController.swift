//
//  CartViewController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: UITableViewController, LoginViewControllerDelegate {
    
    var cart: Cart!
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.cart = appDelegate.cart
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func checkOut(sender: AnyObject) {
        if (self.cart.items.count == 0) {
            var alert = UIAlertView(title: "Oh no!", message: "You have no items in your cart! Add some before you can check out.", delegate: self, cancelButtonTitle: "K.");
            alert.show();
            return;
        }
        var loginNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as UINavigationController;
        var loginViewController = loginNavController.viewControllers.first as LoginViewController
        
        loginViewController.delegate = self
        
        self.navigationController!.presentViewController(loginNavController, animated: true, completion: nil);
    }
    
    func loginCancelled() {
        NSLog("Login cancelled")
    }
    
    func loginComplete() {
        NSLog("Login complete")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cart.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cartCell", forIndexPath: indexPath) as CartItemCell
        
        var cartItem = self.cart.items[indexPath.item]
        cell.itemName.text = cartItem.item.name
        cell.itemDescription.text = cartItem.item.info
        cell.itemCost.text = NSString(format:"Price: $%.02f", cartItem.item.cost);
        
        var pre = appDelegate.configuration["uplImagePre"]!
        NSLog("\(cartItem.item.imageName)")
        var url = "\(pre)\(cartItem.item.imageName).png";
        Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.URL).response { (request, response, data, error) -> Void in
            if (error != nil) {
                NSLog("Failed to load image at url \(url)")
                cell.itemImage.image = nil
                return;
            }
            var image = UIImage(data: data as NSData)
            cell.itemImage.image = image
            cell.itemImage.alpha = 0.0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                cell.itemImage.alpha = 1.0
            })
        }

        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.cart.items.removeAtIndex(indexPath.item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

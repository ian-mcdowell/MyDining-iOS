//
//  LocationsViewController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/12/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

class LocationsViewController: UITableViewController {
    
    var locations: Array<Location>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locations = Array<Location>();

        
        self.loadLocations()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLocations() {
        Alamofire.request(.GET, "https://iastate.webfood.com/xmlstart.dca?dx=12345678&mr=123456", parameters: nil, encoding: ParameterEncoding.URL).responseString { (request: NSURLRequest, response: NSHTTPURLResponse?, data: String?, error: NSError?) -> Void in
            if (error != nil) {
                // something bad happened!!
                NSLog("Error loading locations. \(error?.localizedDescription).");
                return;
            }
            NSLog("Request complete.");
            self.parseLocations(data!);
        }
    }
    
    func parseLocations(locations: String) {
        // form valid XML string
        var info: NSData = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<xml>\n\(locations)\n</xml>".dataUsingEncoding(NSUTF8StringEncoding)!
        
        // load into parser
        var doc: TFHpple = TFHpple(HTMLData: info)
        
        // find root
        var elements = doc.searchWithXPathQuery("//menu")
        
        
        // find location element
        var locationElement: TFHppleElement = elements[1] as TFHppleElement
        var locationItems = locationElement.childrenWithTagName("store") as Array<TFHppleElement>
        
        NSLog("There were \(locationItems.count) locations found.")
        
        // parse locations
        for location in locationItems {
            var loc = Location()
            
            loc.name = location.objectForKey("sname")
            loc.id = location.objectForKey("snum").toInt()
            loc.addr1 = location.objectForKey("saddr")
            loc.addr2 = location.objectForKey("saddr2")
            
            loc.active = location.objectForKey("sact") == "1";
            
            self.locations.append(loc);
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as LocationCell

        var location = self.locations[indexPath.item];
        
        cell.locationName.text = location.name
        cell.address1.text = location.addr1
        cell.address2.text = location.addr2
        
        if (location.active == false) {
            cell.backgroundColor = UIColor(white: 0.95, alpha: 1.0);
            cell.locationName.textColor = UIColor.lightGrayColor()
            cell.address1.textColor = UIColor.lightGrayColor()
            cell.address2.textColor = UIColor.lightGrayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.locationName.textColor = UIColor.blackColor();
            cell.address1.textColor = UIColor.blackColor()
            cell.address2.textColor = UIColor.blackColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var location = self.locations[indexPath.item];
        if (location.active == true) {
            return indexPath
        }
        return nil;
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var destinationViewController = segue.destinationViewController as MenuViewController
        destinationViewController.location = self.locations[self.tableView.indexPathForSelectedRow()!.item]
    }
    

}

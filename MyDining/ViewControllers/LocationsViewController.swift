//
//  LocationsViewController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/12/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

class LocationsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var locations: Array<Location>!
    var schedules = Dictionary<Int, Dictionary<Int, (NSDate, NSDate)>>()

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
        Alamofire.request(.GET, "\(Utils.getBaseURL())/xmlstart.dca?dx=12345678&mr=123456", parameters: nil, encoding: ParameterEncoding.URL).responseString { (request: NSURLRequest, response: NSHTTPURLResponse?, data: String?, error: NSError?) -> Void in
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
        
        // parse configuration
        var configurationElement = elements[0] as TFHppleElement
        var configurationItems = configurationElement.childrenWithTagName("cfg") as Array<TFHppleElement>
        
        NSLog("There were \(configurationItems.count) configuration items found");
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        for configuration in configurationItems {
            var key = configuration.objectForKey("k") as String;
            var val = configuration.objectForKey("v") as String;
            
            appDelegate.configuration[key] = val;
        }
        
        // parse schedules
        var schedulesElement = elements[2] as TFHppleElement
        var schedulesItems = schedulesElement.childrenWithTagName("store") as Array<TFHppleElement>
        
        NSLog("There were \(schedulesItems) schedules found.");
        
        for store in schedulesItems {
            var locationID = store.objectForKey("n").toInt()!
            var times = Dictionary<Int, (NSDate, NSDate)>();
            
            var timeElements = store.childrenWithTagName("time") as Array<TFHppleElement>
            for timeElement in timeElements {
                var time = timeElement.objectForKey("t") as NSString
                
                var dayOfWeek = time.substringWithRange(NSMakeRange(0, 1)).toInt()!
                var startTime = time.substringToIndex(5) as NSString
                var endTime = time.substringFromIndex(5) as NSString
                
                var startComps = NSDateComponents()
                startComps.day = (startTime.substringWithRange(NSMakeRange(0, 1)) as String).toInt()!
                startComps.hour = (startTime.substringWithRange(NSMakeRange(1, 2)) as String).toInt()!
                startComps.minute = (startTime.substringWithRange(NSMakeRange(3, 2)) as String).toInt()!
                var startDate = NSCalendar.currentCalendar().dateFromComponents(startComps)!
                
                var endComps = NSDateComponents()
                endComps.day = (endTime.substringWithRange(NSMakeRange(0, 1)) as String).toInt()!
                endComps.hour = (endTime.substringWithRange(NSMakeRange(1, 2)) as String).toInt()!
                endComps.minute = (endTime.substringWithRange(NSMakeRange(3, 2)) as String).toInt()!
                var endDate = NSCalendar.currentCalendar().dateFromComponents(endComps)!
                
                times[dayOfWeek] = (startDate, endDate)
            }

            self.schedules[locationID] = times;
        }
        
        
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
            loc.schedule = self.schedules[loc.id]
            loc.active = location.objectForKey("sact") == "1";
            
            self.locations.append(loc);
        }
        
        self.collectionView.reloadData()
    }
    
/*- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
return itemSet.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
VPRubberCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
[otherCell setBackgroundColor:[self colorForIndexPath:indexPath]];
[otherCell.iconView setImage:[itemSet objectAtIndex:indexPath.row]];
return otherCell;
}*/
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as LocationCell
        
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
            cell.backgroundColor = self.colorForCollectionViewIndexPath(indexPath)
            cell.locationName.textColor = UIColor.whiteColor();
            cell.address1.textColor = UIColor.whiteColor()
            cell.address2.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        var location = self.locations[indexPath.item]
        return location.active
    }
    
    func colorForCollectionViewIndexPath(indexPath: NSIndexPath) -> UIColor! {
        var totalItems = self.locations.count
        var color = CGFloat((200/totalItems)*indexPath.item)
        var g = (((200/totalItems)*indexPath.item)/totalItems)*indexPath.item-40
        if (g<0){
            g = 0
        }
        var b = CGFloat(g)
        
        
        return UIColor(red: (180-color)/255, green: b/255, blue: b/255, alpha: 1.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.frame.size.width, 300)
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
        if (segue.identifier == "showMenu") {
            var destinationViewController = segue.destinationViewController as MenuViewController
            destinationViewController.location = self.locations[self.collectionView.indexPathsForSelectedItems().first!.item]
        }
    }
    

}

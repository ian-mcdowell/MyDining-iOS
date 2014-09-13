//
//  MenuViewController.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/12/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

let reuseIdentifier = "cell"

class MenuViewController: UICollectionViewController {
    
    var stations: Array<MenuStation>!
    var location: Location!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stations = Array<MenuStation>()
        
        self.loadMenu()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMenu() {
        Alamofire.request(.GET, "https://iastate.webfood.com/xmlstoremenu.dca?dx=123456789&s=\(location.id)&op=0", parameters: nil, encoding: ParameterEncoding.URL).responseString { (request: NSURLRequest, response: NSHTTPURLResponse?, data: String?, error: NSError?) -> Void in
            if (error != nil) {
                // something bad happened!!
                NSLog("Error loading menu. \(error?.localizedDescription).");
                return;
            }
            NSLog("Request complete.");
            self.parseMenu(data!);
        }
    }
    
    func parseMenu(menuitems: String) {
        // form valid XML string
        var info: NSData = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<xml>\n\(menuitems)\n</xml>".dataUsingEncoding(NSUTF8StringEncoding)!
        
        // load into parser
        var doc: TFHpple = TFHpple(HTMLData: info)
        
        // find root
        var elements = doc.searchWithXPathQuery("//menu")
        
        
        // find station element
        var stationElement: TFHppleElement = elements[0] as TFHppleElement
        var stationsItems = stationElement.childrenWithTagName("station") as Array<TFHppleElement>
        
        NSLog("There were \(stationsItems.count) stations found.")
        
        // parse stations
        for station in stationsItems {
            var st = MenuStation()
            
            // parse station info
            st.name = station.objectForKey("name");
            st.id = station.objectForKey("id").toInt();
            
            var stationItems = station.childrenWithTagName("item") as Array<TFHppleElement>
            for item in stationItems {
                var i = MenuItem();
                
                // parse each item info
                i.name = item.objectForKey("idesc");
                i.id = item.objectForKey("iid").toInt();
                i.imageName = item.objectForKey("igroup");
                i.cost = NSString(string: item.objectForKey("icost")).doubleValue
                i.info = item.objectForKey("ifdesc");
                
                st.items.append(i);
            }
            self.stations.append(st);
        }
        
        self.collectionView!.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stations.count > 0 ? stations[0].items.count : 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    */

}

//
//  Utils.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import Foundation

class Utils {
    class func getBaseURL() -> String {
        var config = getConfiguration()
        var baseURL: AnyObject? = config["baseURL"]
        return baseURL as String!
    }
    
    class func isDebug() -> Bool {
        var config = getConfiguration()
        var baseURL: AnyObject? = config["debugMode"]
        return baseURL as Bool!
    }
    
    class func getConfiguration() -> Dictionary<String, AnyObject> {
        var filePath = NSBundle.mainBundle().pathForResource("config", ofType: "json");
        var data = NSData(contentsOfFile: filePath!);
        var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as Dictionary<String, AnyObject>;
        return json
    }
    
    class func generateDX() -> Int {
        return Int(((1 + (arc4random()%2)) * 100000000)) + Int((arc4random() % 100000000))
    }
}
//
//  Networking.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import Foundation

class Networking {
    
    class func post(URL: String, data: String, complete: (data: String?, error: NSError?) -> Void) {

        var fullData = "onLoad=[type Function]&i1=" + data
        NSLog(fullData)
        
        var request = NSMutableURLRequest(URL: NSURL(string: URL))
        
        request.HTTPMethod = "POST"
        request.HTTPBody = fullData.dataUsingEncoding(NSUTF8StringEncoding)
        var connection = NSURLConnection(request: request, delegate: self)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if (error == nil) {
                var string = NSString(data: data, encoding: NSUTF8StringEncoding)
                string = string.stringByReplacingOccurrencesOfString("o1=", withString: "");
                complete(data: string, error: nil);
            } else {
                complete(data: nil, error: error)
            }
        })
    }
    
    // helper methods
    func queryString(params: Dictionary<String, String>) -> String {
        var queryString: String = String()
        for (key, value) in params {
            if (queryString.isEmpty) {
                queryString += "?"
            } else {
                queryString += "&"
            }
            queryString += "\(escapeString(key))=\(escapeString(value))"

        }
        return queryString
    }
    
    func escapeString(string: NSString) -> NSString {
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, "!*'\"();:@&=+$,/?%[] ", kCFStringEncodingASCII)
    }
}
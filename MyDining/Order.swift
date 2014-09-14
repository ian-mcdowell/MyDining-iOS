//
//  Order.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class Order: NSObject {
    var location: Location!
    var item: MenuItem!
    var condiments = Array<Condiment>()
    var name: String!
    var specialRequests: String!
    
    var orderDate: NSDate?
}

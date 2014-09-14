//
//  CartItem.swift
//  MyDining
//
//  Created by Arun Kumar Sondhi on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemCost: UILabel!
    @IBOutlet var itemImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

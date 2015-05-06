//
//  CoffeePlaceCell.swift
//  GetCoffee
//
//  Created by Yev Motov on 5/6/15.
//  Copyright (c) 2015 Achieve Motion, Inc. All rights reserved.
//

import UIKit

class CoffeePlaceCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .DisclosureIndicator
    }
}

//
//  SampleTableViewCell.swift
//  Sample1
//
//  Created by TheAppGuruz-New-6 on 04/02/15.
//  Copyright (c) 2015 TheAppGuruz-New-6. All rights reserved.
//

import UIKit

class SampleTableViewCell: UITableViewCell
{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

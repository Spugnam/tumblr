//
//  myTableViewCell.swift
//  tumblr
//
//  Created by quentin picard on 10/12/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {


    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

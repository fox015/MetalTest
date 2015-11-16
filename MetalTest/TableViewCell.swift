//
//  TableViewCell.swift
//  MetalTest
//
//  Created by Rob Gilbert on 16/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
	
	@IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

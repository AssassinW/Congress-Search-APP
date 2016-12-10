//
//  BillTableViewCell.swift
//  SidebarMenu
//
//  Created by WangSichao on 11/30/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet weak var bill_id: UILabel!
    @IBOutlet weak var bill_title: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

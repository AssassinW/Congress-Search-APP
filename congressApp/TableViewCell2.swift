//
//  TableViewCell2.swift
//  SidebarMenu
//
//  Created by WangSichao on 11/30/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    var id:String!
    @IBOutlet weak var content: UIButton!
    @IBAction func mylink(_ sender: UIButton) {
        var s = ""
        switch title.text! {
        case "Twitter":
            s = "https://www.twitter.com/\(id!)"
        case "Facebook":
            s = "https://www.facebook.com/\(id!)"
        case "N.A.":
            return
        default:
            s = id!
        }
        print(s)
        let url = URL(string:s)
        UIApplication.shared.openURL(url!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

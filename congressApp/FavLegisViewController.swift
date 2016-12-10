//
//  LegisViewController.swift
//  SidebarMenu
//
//  Created by WangSichao on 11/27/16.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class FavLegisViewController: UITableViewController{
    
    var tableData = [[String]]()
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet var tblJSON: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create the search bar
        tableData = UserDefaults.standard.value(forKey: "legislators") as! [[String]]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //make the menu button work
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        var dict = tableData[indexPath.row]
        cell.textLabel?.text = ""
        cell.textLabel?.text?.append(dict[2])
        cell.textLabel?.text?.append(",")
        cell.textLabel?.text?.append(dict[1])
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = dict[3]
        if let bioguide_id:String = dict[0]{
            cell.imageView?.sd_setImage(with: URL(string:"https://theunitedstates.io/images/congress/original/\(bioguide_id).jpg"), placeholderImage: UIImage(named:"placeholder"))
        }
        // Configure the cell...
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! LegisDetailViewController
                controller.congressman = tableData[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
}

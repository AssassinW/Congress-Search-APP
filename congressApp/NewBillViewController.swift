//
//  BillViewController.swift
//  SidebarMenu
//
//  Created by WangSichao on 11/30/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class NewBillViewController: UITableViewController ,UISearchResultsUpdating{
    
    var tableData = [[String:AnyObject]]()
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet var tblJSON: UITableView!
    var filteredTableData = [[String:AnyObject]]()
    var resultSearchController = UISearchController()
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "official_title CONTAINS[cd] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [[String : AnyObject]]
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://awesomeapp.i4a5jetas8.us-west-2.elasticbeanstalk.com/serv.php?search_field=newbills"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                //print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    let json_result = JSON(result)
                    if let resData = json_result["results"].arrayObject {
                        self.tableData = resData as! [[String:AnyObject]]
                    }
                    
                    if self.tableData.count > 0{
                        self.tblJSON.reloadData()
                    }
                }
        }
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.navigationItem.titleView = controller.searchBar
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.placeholder = "Bills"
            
            return controller
        })()
        
        self.tableView.reloadData()
        
        //make the menu button work
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if (self.resultSearchController.isActive) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.resultSearchController.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
            var dict = filteredTableData[indexPath.row]
            var text:String = ""
            text += (dict["bill_id"] as?String)!
            text += "\n"
            text += (dict["official_title"]as?String)!
            cell.textLabel?.text = text
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = dict["introduced_on"] as? String
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
            var dict = tableData[indexPath.row]
            var text:String = ""
            text += (dict["bill_id"] as?String)!
            text += "\n"
            text += (dict["official_title"]as?String)!
            cell.textLabel?.text = text
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = dict["introduced_on"] as? String
            return cell
            
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let bill_id = tableData[indexPath.row]["bill_id"]! as! String
                let bill_title = tableData[indexPath.row]["official_title"]! as! String
                let bill_type = tableData[indexPath.row]["bill_type"]! as! String
                var sponsor = tableData[indexPath.row]["sponsor"]?["title"]! as! String
                sponsor.append(" ")
                sponsor.append(tableData[indexPath.row]["sponsor"]?["first_name"]! as! String)
                sponsor.append(" ")
                sponsor.append(tableData[indexPath.row]["sponsor"]?["last_name"]! as! String)
                let action = tableData[indexPath.row]["last_action_at"]! as! String
                var pdf:String = ""
                if tableData[indexPath.row]["last_version"] == nil{
                    pdf = "N.A."
                }
                else{
                    let layer = tableData[indexPath.row]["last_version"] as![String:AnyObject]
                    if layer["urls"] == nil{
                        pdf = "N.A."
                    }
                    else{
                        let layer2 = layer["urls"] as! [String:AnyObject]
                        if layer2["pdf"] == nil{
                            pdf = "N.A."
                        }
                        else{
                            pdf = layer2["pdf"] as! String
                        }
                    }
                }
                let chamber = tableData[indexPath.row]["chamber"]! as! String
                var vote = ""
                if tableData[indexPath.row]["last_vote_at"] is NSNull || tableData[indexPath.row]["last_vote_at"] == nil{
                    vote = "N.A."
                }
                else{
                    vote = tableData[indexPath.row]["last_vote_at"]! as! String
                }
                var status:String = ""
                if tableData[indexPath.row]["history"] == nil || tableData[indexPath.row]["history"]!["active"] == nil{
                    status = "N.A."
                }
                else{
                    if tableData[indexPath.row]["history"]!["active"] as! Bool{
                        status = "Active"
                    }
                    else{
                        status = "new"
                    }
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! BillDetailViewController
                controller.billData = [bill_title,bill_id,bill_type,sponsor,action,pdf,chamber,vote,status]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

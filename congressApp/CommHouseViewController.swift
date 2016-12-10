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

class CommHouseViewController: UITableViewController ,UISearchResultsUpdating{
    var tableData = [[String:AnyObject]]()
    var totalData = [[String:AnyObject]]()
    var filteredTableData = [[String:AnyObject]]()
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [[String : AnyObject]]
        
        self.tableView.reloadData()
    }
    
    
    
    var resultSearchController = UISearchController()
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet var tblJSON: UITableView!
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create the search bar
        let url = "http://awesomeapp.i4a5jetas8.us-west-2.elasticbeanstalk.com/serv.php?search_field=committees"
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
                        self.totalData = resData as! [[String:AnyObject]]
                    }
                    for item in self.totalData {
                        if item["chamber"] as! String == "house" {
                            self.tableData.append(item)
                        }
                    }
                    self.totalData.removeAll()
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
            controller.searchBar.placeholder = "Committees"
            
            return controller
        })()
        
        self.tableView.reloadData()
        
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
    //define the search bar in title
    
    //dismiss the keyboar, don't know why it doesn't work
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    //dismiss the keyboard when submit
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "commCell", for: indexPath)
            var dict = filteredTableData[indexPath.row]
            cell.textLabel?.text = dict["name"] as?String
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = dict["committee_id"] as? String
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commCell", for: indexPath)
            var dict = tableData[indexPath.row]
            cell.textLabel?.text = dict["name"] as?String
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = dict["committee_id"] as? String
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let name:String = tableData[indexPath.row]["name"]! as! String
                let id:String = tableData[indexPath.row]["committee_id"]! as! String
                var parent:String = ""
                if tableData[indexPath.row]["parent_committee_id"] == nil || tableData[indexPath.row]["parent_committee_id"] is NSNull{
                    parent = "N.A."
                }
                else {
                    parent = tableData[indexPath.row]["parent_committee_id"]! as! String
                }
                let chamber:String = tableData[indexPath.row]["chamber"]! as! String
                var office:String = ""
                if(tableData[indexPath.row]["office"] is NSNull || tableData[indexPath.row]["office"] == nil){
                    office = "N.A."
                }
                else{
                    office = tableData[indexPath.row]["office"]! as! String
                }
                var contact:String = ""
                if(tableData[indexPath.row]["phone"] is NSNull || tableData[indexPath.row]["phone"] == nil){
                    contact = "N.A."
                }
                else{
                    contact = tableData[indexPath.row]["phone"]! as! String
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! CommDetailViewController
                controller.commData = [name,id,parent,chamber,office,contact]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
}

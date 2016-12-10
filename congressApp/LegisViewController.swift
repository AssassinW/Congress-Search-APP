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

class LegisViewController: UITableViewController ,UISearchBarDelegate{
    
    var tableData = [[String:AnyObject]]()
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet var tblJSON: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create the search bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Filter",style:.plain,target:self,action:#selector(Picker(sender:)))
        let url = "http://awesomeapp.i4a5jetas8.us-west-2.elasticbeanstalk.com/serv.php?search_field=legislators"
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
        cell.textLabel?.text?.append((dict["last_name"] as? String)!)
        cell.textLabel?.text?.append(",")
        cell.textLabel?.text?.append((dict["first_name"] as? String)!)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = dict["state_name"] as? String
        if let bioguide_id = dict["bioguide_id"]{
            cell.imageView?.sd_setImage(with: URL(string:"https://theunitedstates.io/images/congress/original/\(bioguide_id).jpg"), placeholderImage: UIImage(named:"placeholder"))
        }
        // Configure the cell...
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let last_name:String = tableData[indexPath.row]["last_name"]! as! String
                let birthday:String = tableData[indexPath.row]["birthday"]! as! String
                let first_name:String = tableData[indexPath.row]["first_name"]! as! String
                let bioguide_id:String = tableData[indexPath.row]["bioguide_id"]! as! String
                let state:String = tableData[indexPath.row]["state"]! as! String
                let gender:String = tableData[indexPath.row]["gender"]! as! String
                let chamber:String = tableData[indexPath.row]["chamber"]! as! String
                var fax:String = ""
                if(tableData[indexPath.row]["fax"] is NSNull){
                    fax = "N.A."
                }
                else{
                    fax = tableData[indexPath.row]["fax"]! as! String
                }
                var twitter:String = ""
                if(tableData[indexPath.row]["twitter_id"] == nil){
                    twitter = "N.A."
                }
                else{
                    twitter = tableData[indexPath.row]["twitter_id"]! as! String
                }
                var facebook:String = ""
                if(tableData[indexPath.row]["facebook_id"] == nil || tableData[indexPath.row]["facebook_id"] is NSNull){
                    facebook = "N.A."
                }
                else{
                    facebook = tableData[indexPath.row]["facebook_id"]! as! String
                }
                var website:String = ""
                if(tableData[indexPath.row]["website"] == nil || tableData[indexPath.row]["website"] is NSNull){
                    website = "N.A."
                }
                else{
                    website = tableData[indexPath.row]["website"]! as! String
                }
                var office:String = ""
                if(tableData[indexPath.row]["office"] == nil){
                    office = "N.A."
                }
                else{
                    office = tableData[indexPath.row]["office"]! as! String
                }
                var term:String = ""
                if(tableData[indexPath.row]["term_end"] is NSNull){
                    term = ""
                }
                else{
                    term = tableData[indexPath.row]["term_end"]! as! String
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! LegisDetailViewController
                controller.congressman = [bioguide_id,first_name,last_name,state,birthday,gender,chamber,fax,twitter,facebook,website,office,term]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    func Picker(sender: UIBarButtonItem) {
        print("to do")
    }
    
}

//
//  LegisDetailViewController.swift
//  SidebarMenu
//
//  Created by WangSichao on 11/28/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage
struct cellData {
    var type: Int!
    var title: String!
    var content: String!
}
class LegisDetailViewController: UITableViewController {
    
    func op(sender:UIBarButtonItem){
        if UserDefaults.standard.value(forKey: "legislators") == nil{
            UserDefaults.standard.set([[String]](), forKey: "legislators")
            print("initiation")
        }
        if congressman?.count != 0{
            var arr = UserDefaults.standard.value(forKey: "legislators") as! [[String]]
            if arr.count == 0{
                arr.append(congressman!)
                UserDefaults.standard.set(arr, forKey: "legislators")
                print("first item added")
                self.navigationItem.rightBarButtonItem?.title = "DelFav"
                return
            }
            for i in 0...arr.count-1{
                if arr[i][0] == congressman?[0]{
                    arr.remove(at: i)
                    UserDefaults.standard.set(arr, forKey: "legislators")
                    print("item deleted")
                    self.navigationItem.rightBarButtonItem?.title = "AddFav"
                    return
                }
                
            }
            arr.append(congressman!)
            UserDefaults.standard.set(arr, forKey: "legislators")
            print("item added")
            self.navigationItem.rightBarButtonItem?.title = "DelFav"
        }
    }
//  [bioguide_id,first_name,last_name,state,birthday,gender,chamber,fax,twitter,facebook,website,office,term]
    var cellDataArray : [cellData] = []
    
    var congressman:[String]?{
        didSet{
            configureView()
        }
    }
    func setColor(){
        if UserDefaults.standard.value(forKey: "legislators") == nil{
            UserDefaults.standard.set([[String]](), forKey: "legislators")
        }
        if congressman?.count != 0{
            var arr = UserDefaults.standard.value(forKey: "legislators") as! [[String]]
            if arr.count == 0{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"AddFav", style: .plain, target: self, action: #selector(op(sender:)))
                return
            }
            for i in 0...arr.count-1{
                if arr[i][0] == congressman?[0]{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"DelFav", style: .plain, target: self, action: #selector(op(sender:)))
                    return
                }
            }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"AddFav", style: .plain, target: self, action: #selector(op(sender:)))
        }
    }
    func configureView(){
        
        cellDataArray = [cellData(type: 1, title:"Bioguide id",content: congressman?[0]),cellData(type: 2, title:"First Name",content: congressman?[1]),
        cellData(type: 2, title:"Last Name",content: congressman?[2]),cellData(type: 2, title:"State",content: congressman?[3]),cellData(type: 2, title:"Birthday",content: congressman?[4]),cellData(type: 2, title:"Gender",content: congressman?[5]),cellData(type: 2, title:"Chamber",content: congressman?[6]),cellData(type: 2, title:"Fax No.",content: congressman?[7]),cellData(type: 3, title:"Twitter",content: congressman?[8]),cellData(type: 3, title:"Facebook",content: congressman?[9]),cellData(type: 3, title:"Website",content: congressman?[10]),cellData(type: 2, title:"Office",content: congressman?[11]),cellData(type: 2, title:"Term End On",content: congressman?[12])]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()
        configureView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellDataArray[indexPath.row].type == 1{
            let cell = Bundle.main.loadNibNamed("ImageTableViewCell", owner: self, options: nil)?.first as! ImageTableViewCell
            cell.myImage.sd_setImage(with: URL(string:"https://theunitedstates.io/images/congress/original/\(cellDataArray[indexPath.row].content!).jpg"), placeholderImage: UIImage(named:"placeholder"))
            return cell
        }
        else if cellDataArray[indexPath.row].type == 2{
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            cell.title.text = cellDataArray[indexPath.row].title
            cell.content.text = cellDataArray[indexPath.row].content
            return cell
        }
        else{
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.title.text = cellDataArray[indexPath.row].title
            cell.content.setTitle(cellDataArray[indexPath.row].title+" Link", for: .normal)
            cell.id = cellDataArray[indexPath.row].content
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellDataArray[indexPath.row].type == 1{
            return 180
        }
        else {
            return 44
        }

    }
}

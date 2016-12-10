//
//  BillDetailViewController.swift
//  SidebarMenu
//
//  Created by WangSichao on 11/30/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

//[bill_title,bill_id,bill_type,sponsor,action,pdf,chamber,vote,status]
class BillDetailViewController: UITableViewController {
    
    func op(sender:UIBarButtonItem){
        if UserDefaults.standard.value(forKey: "bills") == nil{
            UserDefaults.standard.set([[String]](), forKey: "bills")
            print("initiation")
        }
        if billData?.count != 0{
            var arr = UserDefaults.standard.value(forKey: "bills") as! [[String]]
            if arr.count == 0{
                arr.append(billData!)
                UserDefaults.standard.set(arr, forKey: "bills")
                print("first item added")
                self.navigationItem.rightBarButtonItem?.title = "DelFav"
                return
            }
            for i in 0...arr.count-1{
                if arr[i][0] == billData?[0]{
                    arr.remove(at: i)
                    UserDefaults.standard.set(arr, forKey: "bills")
                    print("item deleted")
                    self.navigationItem.rightBarButtonItem?.title = "AddFav"
                    return
                }
                
            }
            arr.append(billData!)
            UserDefaults.standard.set(arr, forKey: "bills")
            print("item added")
            self.navigationItem.rightBarButtonItem?.title = "DelFav"
        }
    }
    
    
    func setColor(){
        if UserDefaults.standard.value(forKey: "bills") == nil{
            UserDefaults.standard.set([[String]](), forKey: "bills")
        }
        if billData?.count != 0{
            var arr = UserDefaults.standard.value(forKey: "bills") as! [[String]]
            if arr.count == 0{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"AddFav", style: .plain, target: self, action: #selector(op(sender:)))
                return
            }
            for i in 0...arr.count-1{
                if arr[i][0] == billData?[0]{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"DelFav", style: .plain, target: self, action: #selector(op(sender:)))
                    return
                }
            }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"AddFav", style: .plain, target: self, action: #selector(op(sender:)))
        }
    }

    var billData:[String]?{
        didSet{
            configureView()
        }
    }
    var cellDataArray : [cellData] = []
    func configureView(){
        cellDataArray = [cellData(type : 1, title:"",content:billData?[0]),cellData(type : 2, title:"Bill ID",content:billData?[1]),cellData(type : 2, title:"Bill Type",content:billData?[2]),cellData(type : 2, title:"Sponsor",content:billData?[3]),cellData(type : 2, title:"Last Action",content:billData?[4]),cellData(type : 3, title:"PDF",content:billData?[5]),cellData(type : 2, title:"Chamber",content:billData?[6]),cellData(type : 2, title:"Last Vote",content:billData?[7]),cellData(type : 2, title:"Status",content:billData?[8])]
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellDataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellDataArray[indexPath.row].type == 1{
            let cell = Bundle.main.loadNibNamed("TableViewCell3", owner: self, options: nil)?.first as! TableViewCell3
            cell.title.text = cellDataArray[indexPath.row].content
            cell.title.lineBreakMode = .byWordWrapping
            cell.title.numberOfLines = 0
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
            return 155
        }
        else {
            return 44
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

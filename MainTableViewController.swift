//
//  MainTableViewController.swift
//  free3
//
//  Created by D7703_21 on 2017. 11. 2..
//  Copyright © 2017년 D7703_21. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, XMLParserDelegate {
    let listEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
    
    let serviceKey = "qzlVqmGoLRO5ZJQkCQJoOSAUWMmoWvgxArZ6e5Mw6OXQ7CkfUuiSKVb3t89PfI1oBtbJnWlho2N73nn66aID6g%3D%3D"
    
    let detailEndPoint =  "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersDetailsInfo"
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var key = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for : .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.plist")
        
        if fileManager.fileExists(atPath: url!.path){
            items = NSArray(contentsOf: url!)as!Array
        }else{
            getList()
            let tempList = items
            items = []
            for tempItem  in tempList {
                getDetail(idx: tempItem["idx"]!)
                
            }
            
            
            let temp = items as NSArray
            temp.write(to: url!, atomically: true)
            

        }
        
               tableView.reloadData()
        
    }
    
    func getList(){
        let str = listEndPoint + "?serviceKey=\(serviceKey)&numOfRows=10"
        
        if let url = URL(string: str){
            if let parser = XMLParser(contentsOf: url){
                parser.delegate = self
                let isSuccess = parser.parse()
                if isSuccess {
                    print("성공")
                }else{
                    print("실패")
                }
            }
        }

    }
    
    func getDetail(idx:String){
        let str = detailEndPoint + "?serviceKey=\(serviceKey)&idx=\(idx)"
        
        if let url = URL(string: str){
            if let parser = XMLParser(contentsOf: url){
                parser.delegate = self
                let isSuccess = parser.parse()
                if isSuccess {
                    print("성공")
                }else{
                    print("실패")
                }
            }
        }
        
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        key = elementName
        if key == "item" {
            item = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("key : \(key) value : \(string)")
        if item[key] == nil {
        item[key] = string.trimmingCharacters(in: .whitespaces)
        }
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
             items.append(item)
        }
        
    }
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let dic = items[indexPath.row]
        cell.textLabel?.text = dic["name"]
        return cell
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

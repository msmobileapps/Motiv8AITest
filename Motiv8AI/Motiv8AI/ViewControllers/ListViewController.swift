//
//  ListViewController.swift
//  Motiv8AI
//
//  Created by MSApps on 21/01/2021.
//

import UIKit

class ListViewController: UITableViewController {

    @IBOutlet weak var searchView: UITextField!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UIBarButtonItem!
    var searchBegin = false
    var searchViewOpen = false
    var listItems = [ListItem]()
    var listItemsfilterd = [ListItem]()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.alpha = 0
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBegin ? listItemsfilterd.count : listItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchBegin ? listItemsfilterd[indexPath.row] : listItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListViewCell
        cell.setCellInfo(item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == listItems.count - 1 && searchView.text!.isEmpty){
            cell.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIView.animate(withDuration: 0.6) {
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
    @IBAction func startBtnDidPress(_ sender: UIBarButtonItem) {
        WebSocketManager.sharedInstance.startConnection()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.getDataFromWebSocket), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopBtnDidPress(_ sender: UIBarButtonItem) {
        WebSocketManager.sharedInstance.stopConnection()
        timer.invalidate()
    }
    
    @objc func getDataFromWebSocket(){
        WebSocketManager.sharedInstance.getData { [self] (listItem) in
            if let item  = listItem {
                listItems.append(item)
                self.tableView.reloadData()
                filterArry(value: searchView.text!)
                if(searchView.text!.isEmpty){
                    scrollToBottom()
                    titleLabel.title = item.name
                }
            }
        }
    }
    
    @IBAction func searchDidPress(_ sender: UIBarButtonItem) {
        searchViewOpen = !searchViewOpen
        searchBtn.image = searchViewOpen ? UIImage(named: "icons8-x") : UIImage(named: "icons8-search")
        searchView.alpha = searchViewOpen ? 1 : 0
        self.tableView.reloadData()
        searchView.text = ""
        
    }
    
    func filterArry(value: String){
        listItemsfilterd = listItems.filter { word in
            if(value.isEmpty){
               return true
            }else{
               return word.name.localizedCaseInsensitiveContains(value)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func searchBegin(_ sender: UITextField) {
        searchBegin = !sender.text!.isEmpty
        titleLabel.title = ""
        filterArry(value: sender.text!)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.listItems.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

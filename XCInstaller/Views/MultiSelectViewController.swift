//
//  MultiSelectViewController.swift
//  XCInstaller
//
//  Created by VR on 24/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Cocoa

class MultiSelectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    class var storybaordIdentifier:String{
        "MultiSelectViewController"
    }
    
    @IBOutlet weak var tableView:NSTableView!
    
    private(set) var dataSource: [[String: String]] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func instantiate() -> MultiSelectViewController {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateController(withIdentifier:storybaordIdentifier) as! MultiSelectViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.tableView.reloadData()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.dataSource.count
    }
    
    func setDataSource(_ items:[[String:String]]){
        self.dataSource = items
    }
    
    
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("multiselectcell"), owner: self) as? MultiSelectTableCell else { return nil}
    
    let devicedic = dataSource[row]
    cell.configureData(devicedic as [String : AnyObject])
    return cell
    }
    
}



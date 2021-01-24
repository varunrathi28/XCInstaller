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
    private var viewModel:DeviceSelectionViewModel!
    var completion:(([String]) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func instantiate(_ viewModel:DeviceSelectionViewModel, _ completionHandler: (([String]) -> Void)?) -> MultiSelectViewController {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateController(withIdentifier:storybaordIdentifier) as! MultiSelectViewController
        viewController.viewModel = viewModel
        viewController.completion = completionHandler
        return viewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.completion?(self.viewModel.getSelectedDeviceIds())
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.viewModel.numberOfRows
    }
    
    func setDataSource(_ items:[[String:String]]){
        self.dataSource = items
    }
    
    
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("multiselectcell"), owner: self) as? MultiSelectTableCell else { return nil}
    let cellVM = self.viewModel.cellModel(at: NSIndexPath(forItem: row, inSection: 0))
    cell.configureData(cellVM)
    return cell
    }
    
}



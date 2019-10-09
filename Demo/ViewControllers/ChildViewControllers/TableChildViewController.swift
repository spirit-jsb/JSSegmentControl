//
//  TableChildViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/24.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class TableChildViewController: UIViewController {

    // MARK:
    private let identifier = "com.sibo.jian.segment.tableview.child"
    
    weak var childScrollDelegate: ChildScrollViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TableChildViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "Row ---- \(indexPath.row)"
        return cell
    }
}

extension TableChildViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TableChildViewController: UIScrollViewDelegate {
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.childScrollDelegate?.childScrollViewDidScroll(scrollView)
    }
}

//
//  RxTest11TableViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/24.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class RxTest11TableViewController: UITableViewController {
    
    // MARK:
    weak var scrollDelegate: ChildScrollViewDelegate?
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load \(#file)")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    }
    
    // MARK:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear \(#file)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear \(#file)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View Will Disappear \(#file)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View Did Disappear \(#file)")
    }
    
    deinit {
        print("Deinit \(#file)")
    }
}

extension RxTest11TableViewController {
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "Row ---- \(indexPath.row)"
        return cell
    }
}

extension RxTest11TableViewController {
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RxTest11TableViewController {
    
    // MARK: UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.childScrollViewDidScroll(scrollView)
    }
}

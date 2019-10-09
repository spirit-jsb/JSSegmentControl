//
//  CustomTableViewViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/26.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class CustomTableView: UITableView {
    
}

extension CustomTableView: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer is UIPanGestureRecognizer) && (otherGestureRecognizer is UIPanGestureRecognizer)
    }
}

class CustomTableViewViewController: UIViewController {

    // MARK:
    var tableView: CustomTableView?
    var segmentControl: JSSegmentControl?
    var childScrollView: UIScrollView?
    
    var dataSource: [(CustomSegmentTitleDataSource, CustomSegmentChildViewControllerDataSource)] = [
        (.title("关注"), .tableChild), (.title("头条"), .collectionChild), (.title("视频"), .tableChild), (.title("娱乐"), .collectionChild),
        (.title("体育"), .tableChild), (.title("新时代"), .collectionChild), (.title("要闻"), .tableChild), (.title("段子"), .collectionChild),
        (.title("知否"), .tableChild), (.title("上海"), .collectionChild), (.title("公开课"), .tableChild), (.title("圈子"), .collectionChild),
        (.title("财经"), .tableChild), (.title("科技"), .collectionChild), (.title("汽车"), .tableChild), (.title("网易号"), .collectionChild)
    ]
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constructView()
        self.constructViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.constructNavigationBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    override var automaticallyAdjustsScrollViewInsets: Bool {
        set {
            super.automaticallyAdjustsScrollViewInsets = newValue
        }
        get {
            return false
        }
    }
    
    override var edgesForExtendedLayout: UIRectEdge {
        set {
            super.edgesForExtendedLayout = newValue
        }
        get {
            return UIRectEdge(rawValue: 0)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.makeViewConstraints()
    }
    
    // MARK:
    private func constructView() {
        let tableHeaderView = UIView()
        tableHeaderView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 150.0)
        tableHeaderView.backgroundColor = UIColor.orange
        
        self.tableView = CustomTableView(frame: .zero, style: .grouped)
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.tableHeaderView = tableHeaderView
        self.tableView?.estimatedRowHeight = UITableView.automaticDimension
        self.tableView?.sectionHeaderHeight = 50.0
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.showsHorizontalScrollIndicator = false
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        }
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        self.tableView?.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header_identifier")
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView!)
        
        var titleStyle = TitleStyle()
        titleStyle.isLineHidden = false
        titleStyle.isAdjustMaskAndLineSize = false
        titleStyle.spacing = 10.0
        titleStyle.lineWidth = 40.0
        titleStyle.lineHeight = 3.0
        titleStyle.lineColor = UIColor.red
        titleStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)
        
        var titleContainerStyle = TitleContainerStyle()
        titleContainerStyle.titleFont = UIFont.boldSystemFont(ofSize: 16.0)
        titleContainerStyle.titleTextColor = UIColor.black
        titleContainerStyle.titleHighlightedTextColor = UIColor.red
        titleContainerStyle.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 8.0)
        titleContainerStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)

        let contentStyle = ContentStyle()
        
        self.segmentControl = JSSegmentControl(titleStyle: titleStyle, titleContainerStyle: titleContainerStyle, contentStyle: contentStyle, parent: self)
                
        self.view.needsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    // MARK:
    private func constructViewController() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func constructNavigationBar() {
        self.navigationItem.title = "Custom Table View"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MAKR:
    private func makeViewConstraints() {
        guard let strongTableView = self.tableView else {
            return
        }
        
        let tableViewLeading = strongTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let tableViewTop = strongTableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let tableViewTrailing = strongTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let tableViewBottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            tableViewBottom = strongTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        }
        else {
            tableViewBottom = strongTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        NSLayoutConstraint.activate([tableViewLeading, tableViewTop, tableViewTrailing, tableViewBottom])
    }
}

extension CustomTableViewViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let strongSegmentControl = self.segmentControl else {
            return cell
        }
        
        cell.contentView.addSubview(strongSegmentControl.contentView)
        
        let contentLeading = strongSegmentControl.contentView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor)
        let contentTop = strongSegmentControl.contentView.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
        let contentTrailing = strongSegmentControl.contentView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
        let contentBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        NSLayoutConstraint.activate([contentLeading, contentTop, contentTrailing, contentBottom])
        
        return cell
    }
}

extension CustomTableViewViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height - tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header_identifier") else {
            return nil
        }
        header.contentView.backgroundColor = UIColor.white
        header.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let strongSegmentControl = self.segmentControl else {
            return header
        }
        
        header.contentView.addSubview(self.segmentControl!.titleView)
        
        let titleViewLeading = strongSegmentControl.titleView.leadingAnchor.constraint(equalTo: header.contentView.leadingAnchor)
        let titleViewTrailing = strongSegmentControl.titleView.trailingAnchor.constraint(equalTo: header.contentView.trailingAnchor)
        let titleViewCenterY = strongSegmentControl.titleView.centerYAnchor.constraint(equalTo: header.contentView.centerYAnchor)
        NSLayoutConstraint.activate([titleViewLeading, titleViewTrailing, titleViewCenterY])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension CustomTableViewViewController: UIScrollViewDelegate {
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let strongTableHeaderView = self.tableView?.tableHeaderView,
            let strongChildScrollView = self.childScrollView else
        {
            return
        }
        
        if strongChildScrollView.contentOffset.y > 0.0 {
            scrollView.contentOffset.y = strongTableHeaderView.bounds.height
        }
    }
}

extension CustomTableViewViewController: JSSegmentControlDataSource {
    
    // MARK: JSSegmentControlDataSource
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        title.title = self.dataSource[index].0.title
        return title
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        var content = segmentControl.dequeueReusableContent(at: index)
        if content == nil {
            content = self.dataSource[index].1.viewController
            if content is UIScrollViewDelegate {
                if let collectionChild = content as? CollectionChildViewController {
                    collectionChild.childScrollDelegate = self
                }
                else if let tableChild = content as? TableChildViewController {
                    tableChild.childScrollDelegate = self
                }
            }
        }
        return content!
    }
}

extension CustomTableViewViewController: JSSegmentControlDelegate {
    
    // MARK: JSSegmentControlDelegate
    func segmentControl(_ segmentControl: JSSegmentControl, didSelectAt index: Int) {
        print("Did Select At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didDeselectAt index: Int) {
        print("Did Deselect At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, willAppear controller: UIViewController, forItemAt index: Int) {
        print("Will Appear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didAppear controller: UIViewController, forItemAt index: Int) {
        print("Did Appear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, willDisappear controller: UIViewController, forItemAt index: Int) {
        print("Will Disappear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didDisappear controller: UIViewController, forItemAt index: Int) {
        print("Did Disappear At \(index)")
    }
}

extension CustomTableViewViewController: ChildScrollViewDelegate {
    
    // MARK: ChildScrollViewDelegate
    func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
        self.childScrollView = childScrollView
        
        guard let strongTableView = self.tableView,
            let strongTableHeaderView = self.tableView?.tableHeaderView else
        {
            return
        }
        
        if strongTableView.contentOffset.y < strongTableHeaderView.bounds.height {
            childScrollView.contentOffset = CGPoint.zero
        }
        else {
            strongTableView.contentOffset = CGPoint(x: 0.0, y: strongTableHeaderView.bounds.height)
        }
    }
}

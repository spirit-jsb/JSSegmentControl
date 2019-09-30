//
//  DotBadgeViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/25.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class DotBadgeViewController: UIViewController {

    // MARK:
    var segmentControl: JSSegmentControl?
    
    var dataSource: [(CustomSegmentTitleDataSource, CustomSegmentChildViewControllerDataSource, CustomSegmentBadgeDataSource)] = [
        (.title("推荐"), .tableChild, .badge(0)), (.title("小视频"), .buttonChild, .badge(10)), (.title("榜单"), .collectionChild, .badge(9)), (.title("超级IP季"), .child, .badge(0))
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
        var titleStyle = TitleStyle()
        titleStyle.isZoomEnabled = true
        titleStyle.isAdjustContainerSize = false
        titleStyle.containerWidth = 80.0
        titleStyle.containerHeight = 35.0
        titleStyle.spacing = 10.0
        titleStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: -5.0, right: -10.0)
        
        var titleContainerStyle = TitleContainerStyle()
        titleContainerStyle.isBadgeHidden = false
        titleContainerStyle.badgeBackgroundColor = UIColor.white
        titleContainerStyle.badgeBorderColor = UIColor.red.cgColor
        titleContainerStyle.badgeBorderWidth = 2.0
        titleContainerStyle.titleFont = UIFont.boldSystemFont(ofSize: 16.0)
        titleContainerStyle.titleTextColor = UIColor.black
        titleContainerStyle.titleHighlightedTextColor = UIColor.red
        titleContainerStyle.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 17.5, right: 0.0)
        titleContainerStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)

        let contentStyle = ContentStyle()
        
        self.segmentControl = JSSegmentControl(titleStyle: titleStyle, titleContainerStyle: titleContainerStyle, contentStyle: contentStyle, parent: self)
        
        self.view.addSubview(self.segmentControl!.titleView)
        self.view.addSubview(self.segmentControl!.contentView)
    }
    
    // MARK:
    private func constructViewController() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func constructNavigationBar() {
        self.navigationItem.title = "Dot Badge"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MAKR:
    private func makeViewConstraints() {
        guard let strongSegmentControl = self.segmentControl else {
            return
        }
        
        let titleViewLeading = strongSegmentControl.titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let titleViewTop = strongSegmentControl.titleView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let titleViewTrailing = strongSegmentControl.titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let titleViewBottom = strongSegmentControl.titleView.bottomAnchor.constraint(equalTo: strongSegmentControl.contentView.topAnchor)
        NSLayoutConstraint.activate([titleViewLeading, titleViewTop, titleViewTrailing, titleViewBottom])
        
        let contentViewLeading = strongSegmentControl.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let contentViewTrailing = strongSegmentControl.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let contentViewBottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        }
        else {
            contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        NSLayoutConstraint.activate([contentViewLeading, contentViewTrailing, contentViewBottom])
    }
}

extension DotBadgeViewController: JSSegmentControlDataSource {
    
    // MARK: JSSegmentControlDataSource
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        title.title = self.dataSource[index].0.title
        title.badge = self.dataSource[index].2.badge
        return title
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        var content = segmentControl.dequeueReusableContent(at: index)
        if content == nil {
            content = self.dataSource[index].1.viewController
        }
        return content!
    }
}

extension DotBadgeViewController: JSSegmentControlDelegate {
    
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

//
//  CustomTitleViewViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/25.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class CustomTitleViewViewController: UIViewController {

    // MARK:
    var segmentControl: JSSegmentControl?
    
    var dataSource: [(CustomSegmentTitleDataSource, CustomSegmentChildViewControllerDataSource, CustomSegmentBadgeDataSource)] = [
        (.title("通知"), .tableChild, .badge(13)), (.title("私信"), .collectionChild, .badge(0))
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
        titleStyle.isScrollEnabled = false
        titleStyle.isForceEqualContainerSize = true
        titleStyle.isLineHidden = false
        titleStyle.isAdjustMaskAndLineSize = false
        titleStyle.spacing = 50.0
        titleStyle.lineWidth = 40.0
        titleStyle.lineHeight = 3.0
        titleStyle.lineColor = UIColor.red
        titleStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)
        
        var titleContainerStyle = TitleContainerStyle()
        titleContainerStyle.isBadgeHidden = false
        titleContainerStyle.badgeStyle = .number
        titleContainerStyle.badgeTextColor = UIColor.white
        titleContainerStyle.badgeBackgroundColor = UIColor.red
        titleContainerStyle.badgeBorderColor = UIColor.red.cgColor
        titleContainerStyle.titleFont = UIFont.boldSystemFont(ofSize: 16.0)
        titleContainerStyle.titleTextColor = UIColor.black
        titleContainerStyle.titleHighlightedTextColor = UIColor.red
        titleContainerStyle.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 8.0)
        titleContainerStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)

        let contentStyle = ContentStyle()
        
        self.segmentControl = JSSegmentControl(titleStyle: titleStyle, titleContainerStyle: titleContainerStyle, contentStyle: contentStyle, parent: self)
        
        self.navigationItem.titleView = self.segmentControl?.titleView
        self.view.addSubview(self.segmentControl!.contentView)
        
        self.view.needsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    // MARK:
    private func constructViewController() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func constructNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MAKR:
    private func makeViewConstraints() {
        guard let strongSegmentControl = self.segmentControl else {
            return
        }
        
        let contentViewLeading = strongSegmentControl.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let contentViewTop = strongSegmentControl.contentView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let contentViewTrailing = strongSegmentControl.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let contentViewBottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        }
        else {
            contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        NSLayoutConstraint.activate([contentViewLeading, contentViewTop, contentViewTrailing, contentViewBottom])
    }
}

extension CustomTitleViewViewController: JSSegmentControlDataSource {
    
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

extension CustomTitleViewViewController: JSSegmentControlDelegate {
    
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

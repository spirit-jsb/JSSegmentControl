//
//  Test8ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/21.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class Test8ViewController: UIViewController {

    // MAKR:
    var dataSource = ["国内新闻", "新闻头条"]
    
    var titleContainerStyle = TitleContainerStyle()
    var titleStyle = TitleStyle()
    var contentStyle = ContentStyle()
    
    lazy var titleView = JSTitleView(style: self.titleStyle)
    lazy var contentView = JSContentView(style: self.contentStyle, parent: self)
    let segmentControl = JSSegmentControl()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleContainerStyle.titleFont = UIFont.systemFont(ofSize: 15.0)
        self.titleContainerStyle.titleTextColor = UIColor.red
        self.titleContainerStyle.titleHighlightedTextColor = UIColor.white
        self.titleContainerStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)
        
        self.titleStyle.isScrollEnabled = false
        self.titleStyle.isMaskHidden = false
        self.titleStyle.spacing = 10.0
        self.titleStyle.maskColor = UIColor.red
        
        self.navigationItem.titleView = self.titleView
        self.view.addSubview(self.contentView)
        
        self.segmentControl.title = self.titleView
        self.segmentControl.content = self.contentView
        self.segmentControl.dataSource = self
        self.segmentControl.delegate = self
        
        self.view.setNeedsUpdateConstraints()
    }
    
    // MAKR:
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.contentView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
            else {
                make.top.equalTo(self.view).offset(TOP_MARGIN)
            }
        }
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
}

extension Test8ViewController: JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        var title = segmentControl.dequeueReusableTitle(at: index)
        if title == nil {
            title = JSTitleContainerView(style: self.titleContainerStyle)
        }
        title?.title = self.dataSource[index]
        return title!
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        var content = segmentControl.dequeueReusableContent(at: index)
        
        if content == nil {
            content = Child1ViewController()
        }
        
        return content!
    }
}

extension Test8ViewController: JSSegmentControlDelegate {
    
    func segmentControl(_ segmentControl: JSSegmentControl, didSelectAt index: Int) {
        print("Did Select At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didDeselectAt index: Int) {
        print("Did Deselect At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, controllerWillAppear controller: UIViewController, at index: Int) {
        print("Controller Will Appear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, controllerDidAppear controller: UIViewController, at index: Int) {
        print("Controller Did Appear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, controllerWillDisappear controller: UIViewController, at index: Int) {
        print("Controller Will Disappear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, controllerDidDisappear controller: UIViewController, at index: Int) {
        print("Controller Did Disappear At \(index)")
    }
}

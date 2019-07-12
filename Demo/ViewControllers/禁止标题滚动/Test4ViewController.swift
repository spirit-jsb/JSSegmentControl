//
//  Test4ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/20.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class Test4ViewController: UIViewController {

    // MAKR:
    var dataSource = ["新闻头条", "国际要闻"]
    
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
        self.titleContainerStyle.titleTextColor = UIColor.blue
        self.titleContainerStyle.titleHighlightedTextColor = UIColor.red
        self.titleContainerStyle.position = .center
        self.titleContainerStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)
        
        self.titleStyle.isScrollEnabled = false
        self.titleStyle.spacing = 10.0
        self.titleStyle.edgeInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: -15.0, right: -5.0)
        
        self.view.addSubview(self.titleView)
        self.view.addSubview(self.contentView)
        
        self.segmentControl.title = titleView
        self.segmentControl.content = contentView
        self.segmentControl.dataSource = self
        self.segmentControl.delegate = self
    }
    
    // MAKR:
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
            else {
                make.top.equalTo(self.view).offset(TOP_MARGIN)
            }
            make.bottom.equalTo(self.contentView.snp.top)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
}

extension Test4ViewController: JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        var title = segmentControl.dequeueReusableTitle(at: index)
        if title == nil {
            title = JSTitleContainerView(style: self.titleContainerStyle)
        }
        title?.title = self.dataSource[index]
        title?.image = UIImage(named: "segment_background_normal")
        title?.highlightedImage = UIImage(named: "segment_background_selected")
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

extension Test4ViewController: JSSegmentControlDelegate {
    
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

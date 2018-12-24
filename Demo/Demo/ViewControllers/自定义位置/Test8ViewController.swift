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
    var style = JSSegmentControlStyle()
    
    lazy var segment = JSSegmentControl(segmentStyle: self.style)
    lazy var titleView = JSTitleView(frame: CGRect(origin: .zero, size: CGSize(width: 160.0, height: 30.0)), segmentStyle: self.style)
    lazy var contentView = JSContentView(frame: CGRect(x: 0.0, y: TOP_MARGIN, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN), segmentStyle: self.style, parentViewController: self)
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        self.style.titleContainerStyle.titleTextColor = UIColor.red
        self.style.titleContainerStyle.titleHighlightedTextColor = UIColor.white
        
        self.style.titleStyle.isTitleScroll = false
        self.style.titleStyle.isShowMasks = true
        self.style.titleStyle.maskColor = UIColor.red
        
        self.segment.dataSource = self
        self.segment.delegate = self
        
        self.segment.configuration(titleView: self.titleView, contentView: self.contentView, completionHandle: {
            self.navigationItem.titleView = self.titleView
            self.view.addSubview(self.contentView)
        })
    }
    
    // MAKR:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
}

extension Test8ViewController: JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        
        title.segmentTitle = self.dataSource[index]
        title.segmentBadge = 0
        return title
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

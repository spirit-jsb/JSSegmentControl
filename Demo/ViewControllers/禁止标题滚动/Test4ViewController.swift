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
    var style = JSSegmentControlStyle()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.style.titleContainerStyle.position = .background
        self.style.titleContainerStyle.titleTextColor = UIColor.blue
        self.style.titleContainerStyle.titleHighlightedTextColor = UIColor.red
        
        self.style.titleStyle.isTitleScroll = false
        self.style.titleStyle.titleHeight = 50.0
 
        let segment = JSSegmentControl(frame: CGRect(x: 0.0, y: TOP_MARGIN, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN), segmentStyle: self.style, parentViewController: self)
        segment.dataSource = self
        segment.delegate = self
        self.view.addSubview(segment)
    }
    
    // MAKR:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
}

extension Test4ViewController: JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        
        title.segmentTitle = self.dataSource[index]
        title.segmentImage = UIImage(named: "segment_background_normal")
        title.segmentHighlightedImage = UIImage(named: "segment_background_selected")
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

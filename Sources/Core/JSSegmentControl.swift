//
//  JSSegmentControl.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/19.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

func debugLog(items: String = "", _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if DEBUG
    let tmpFile = file.split(separator: "/").last ?? "null"
    NSLog(">>>> \n FILE: \(tmpFile), LINE: \(line), FUNCTION: \(function) \n \(items) \n <<<<")
    #endif
}

public class JSSegmentControl: NSObject {
    
    // MARK:
    public let titleView: JSTitleView
    public let contentView: JSContentView
    
    public var presentContent: UIViewController? {
        return self.contentView.presentChildController
    }
     
    public weak var dataSource: JSSegmentControlDataSource!
    public weak var delegate: JSSegmentControlDelegate!
        
    // MAKR:
    public init(titleStyle: TitleStyle,
                titleContainerStyle: TitleContainerStyle,
                contentStyle: ContentStyle,
                parent: UIViewController & JSSegmentControlDataSource & JSSegmentControlDelegate)
    {
        self.titleView = JSTitleView(titleStyle: titleStyle, titleContainerStyle: titleContainerStyle)
        self.contentView = JSContentView(contentStyle: contentStyle, parent: parent)
        
        self.dataSource = parent
        self.delegate = parent
        
        super.init()
        
        self.titleView.titleDataSource = self
        self.titleView.titleDelegate = self
        self.contentView.contentDataSource = self
        self.contentView.contentDelegate = self
        
        self.reload()
    }
    
    deinit {        
        debugLog()
    }
    
    // MARK:
    public func dequeueReusableTitle(at index: Int) -> JSTitleContainerView {
        return self.titleView.dequeueReusableTitle(at: index)
    }
    
    public func dequeueReusableContent(at index: Int) -> UIViewController? {
        return self.contentView.dequeueReusableContent(at: index)
    }
    
    public func reload() {
        self.titleView.reload()
        self.contentView.reload()
    }
    
    public func selected(index: Int) {
        self.titleView.selected(index: index)
    }
}

extension JSSegmentControl: JSTitleDataSource {
    
    // MARK: JSTitleDataSource
    func numberOfTitles() -> Int {
        return self.dataSource.numberOfSegments()
    }
    
    func titleView(_ titleView: JSTitleView, containerAt index: Int) -> JSTitleContainerView {
        return self.dataSource.segmentControl(self, titleAt: index)
    }
}

extension JSSegmentControl: JSTitleDelegate {
    
    // MARK: JSTitleDelegate
    func titleView(_ titleView: JSTitleView, didSelectAt index: Int) {
        self.contentView.selected(index: index)
        self.delegate.segmentControl(self, didSelectAt: index)
    }
    
    func titleView(_ titleView: JSTitleView, didDeselectAt index: Int) {
        self.delegate.segmentControl(self, didDeselectAt: index)
    }
}

extension JSSegmentControl: JSContentDataSource {
    
    // MARK: JSTitleDataSource
    func numberOfContents() -> Int {
        return self.dataSource.numberOfSegments()
    }
    
    func contentView(_ contentView: JSContentView, containerAt index: Int) -> UIViewController {
        return self.dataSource.segmentControl(self, contentAt: index)
    }
}

extension JSSegmentControl: JSContentDelegate {
    
    // MARK: JSTitleDelegate
    func contentView(selected index: Int) {
        self.titleView.selected(index: index)
    }
    
    func contentView(selectedAnimation progress: CGFloat, from pastIndex: Int, to presentIndex: Int) {
        self.titleView.selectedAnimation(progress: progress, from: pastIndex, to: presentIndex)
    }
    
    func contentView(_ contentView: JSContentView, willAppear controller: UIViewController, forItemAt index: Int) {
        self.delegate.segmentControl(self, willAppear: controller, forItemAt: index)
    }
    
    func contentView(_ contentView: JSContentView, didAppear controller: UIViewController, forItemAt index: Int) {
        self.delegate.segmentControl(self, didAppear: controller, forItemAt: index)
    }
    
    func contentView(_ contentView: JSContentView, willDisappear controller: UIViewController, forItemAt index: Int) {
        self.delegate.segmentControl(self, willDisappear: controller, forItemAt: index)
    }
    
    func contentView(_ contentView: JSContentView, didDisappear controller: UIViewController, forItemAt index: Int) {
        self.delegate.segmentControl(self, didDisappear: controller, forItemAt: index)
    }
}

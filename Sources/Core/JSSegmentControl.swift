//
//  JSSegmentControl.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/19.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSSegmentControl: NSObject {
    
    // MARK:
    public weak var title: JSTitleView? = nil {
        didSet {
            if let title = self.title, let _ = self.dataSource, let _ = self.delegate {
                title.titleDataSource = self
                title.titleDelegate = self
                title.reload()
            }
        }
    }
    
    public weak var content: JSContentView? = nil {
        didSet {
            if let content = self.content, let _ = self.dataSource, let _ = self.delegate {
                content.contentDataSource = self
                content.contentDelegate = self
                content.reload()
            }
        }
    }
    
    public weak var dataSource: JSSegmentControlDataSource! {
        didSet {
            if let title = self.title, let content = self.content, let _ = self.dataSource {
                title.titleDataSource = self
                title.reload()
                content.contentDataSource = self
                content.reload()
            }
        }
    }
    
    public weak var delegate: JSSegmentControlDelegate? {
        didSet {
            if let title = self.title, let content = self.content, let _ = self.delegate {
                title.titleDelegate = self
                content.contentDelegate = self
            }
        }
    }
    
    // MAKR:
    deinit {
        #if DEBUG
        let function = #function
        let file = #file.split(separator: "/").last ?? "null"
        let line = #line
        print(file, line, function)
        #endif
    }
    
    // MARK:
    public func dequeueReusableTitle(at index: Int) -> JSTitleContainerView? {
        return self.title?.dequeueReusableTitle(at: index)
    }
    
    public func dequeueReusableContent(at index: Int) -> UIViewController? {
        return self.content?.dequeueReusableContent(at: index)
    }
    
    public func reload() {
        self.title?.reload()
        self.content?.reload()
    }
    
    public func selected(index: Int) {
        self.title?.selected(index: index)
    }
}

extension JSSegmentControl: JSTitleDataSource {
    
    // MARK: JSTitleDataSource
    func numberOfTitles() -> Int {
        return self.dataSource.numberOfSegments()
    }
    
    func title(_ title: JSTitleView, containerAt index: Int) -> JSTitleContainerView {
        return self.dataSource.segmentControl(self, titleAt: index)
    }
}

extension JSSegmentControl: JSTitleDelegate {
    
    // MARK: JSTitleDelegate
    func title(_ title: JSTitleView, didSelectAt index: Int) {
        self.content?.selected(index: index)
        self.delegate?.segmentControl?(self, didSelectAt: index)
    }
    
    func title(_ title: JSTitleView, didDeselectAt index: Int) {
        self.delegate?.segmentControl?(self, didDeselectAt: index)
    }
}

extension JSSegmentControl: JSContentDataSource {
    
    // MARK: JSTitleDataSource
    func numberOfContents() -> Int {
        return self.dataSource.numberOfSegments()
    }
    
    func content(_ content: JSContentView, containerAt index: Int) -> UIViewController {
        return self.dataSource.segmentControl(self, contentAt: index)
    }
}

extension JSSegmentControl: JSContentDelegate {
    
    // MARK: JSTitleDelegate
    func content(selected index: Int) {
        self.title?.selected(index: index)
    }
    
    func content(selectedAnimation progress: CGFloat, from pastIndex: Int, to presentIndex: Int) {
        self.title?.selectedAnimation(progress: progress, from: pastIndex, to: presentIndex)
    }
    
    func content(_ content: JSContentView, willAppear controller: UIViewController, forItemAt index: Int) {
        self.delegate?.segmentControl?(self, willAppear: controller, forItemAt: index)
    }
    
    func content(_ content: JSContentView, didAppear controller: UIViewController, forItemAt index: Int) {
        self.delegate?.segmentControl?(self, didAppear: controller, forItemAt: index)
    }
    
    func content(_ content: JSContentView, willDisappear controller: UIViewController, forItemAt index: Int) {
        self.delegate?.segmentControl?(self, willDisappear: controller, forItemAt: index)
    }
    
    func content(_ content: JSContentView, didDisappear controller: UIViewController, forItemAt index: Int) {
        self.delegate?.segmentControl?(self, didDisappear: controller, forItemAt: index)
    }
}

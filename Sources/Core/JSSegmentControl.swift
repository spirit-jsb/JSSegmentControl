//
//  JSSegmentControl.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/19.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSSegmentControl: UIView {

    // MARK: 属性
    public weak var dataSource: JSSegmentControlDataSource?
    public weak var delegate: JSSegmentControlDelegate?
    
    private let style: JSSegmentControlStyle
    
    private weak var parent: UIViewController?
    
    private lazy var titleView: JSTitleView = {
        let titleView = JSTitleView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.style.titleStyle.titleHeight), segmentStyle: self.style)
        titleView.titleDataSource = self
        titleView.titleDelegate = self
        return titleView
    }()
    
    private lazy var contentView: JSContentView = {
        let contentView = JSContentView(frame: CGRect(x: 0.0, y: self.style.titleStyle.titleHeight, width: self.bounds.width, height: self.bounds.height - self.style.titleStyle.titleHeight), segmentStyle: self.style, parentViewController: self.parent!)
        contentView.contentDataSource = self
        contentView.contentDelegate = self
        return contentView
    }()
    
    private var dataSourceCount: Int {
        get {
            return self.dataSource?.numberOfSegments() ?? 0
        }
    }
    
    // MARK: 初始化
    public init(segmentStyle style: JSSegmentControlStyle) {
        self.style = style
        super.init(frame: .zero)
    }

    public init(frame: CGRect, segmentStyle style: JSSegmentControlStyle, parentViewController parent: UIViewController) {
        self.style = style
        self.parent = parent
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("DEINIT: \(#file)")
        #endif
    }
    
    // MARK: 公开方法
    public func dequeueReusableTitle(at index: Int) -> JSTitleContainerView? {
        return self.titleView.dequeueReusableTitle(at: index)
    }
    
    public func dequeueReusableContent(at index: Int) -> UIViewController? {
        return self.contentView.dequeueReusableContent(at: index)
    }
    
    public func reloadData() {
        self.titleView.reloadData()
        self.contentView.reloadData()
    }
    
    public func selectedIndex(_ index: Int) {
        self.titleView.selectedIndex(index)
    }
    
    public func configuration(titleView: JSTitleView, contentView: JSContentView, completionHandle: () -> ()) {
        self.titleView = titleView
        self.contentView = contentView
        
        self.titleView.titleDataSource = self
        self.titleView.titleDelegate = self
        self.contentView.contentDataSource = self
        self.contentView.contentDelegate = self
        
        completionHandle()
    }

    // MARK: 重写父类方法
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setupSubviews()
    }
    
    // MARK: 设置方法
    private func setupSubviews() {
        self.addSubview(self.titleView)
        self.addSubview(self.contentView)
    }
}

extension JSSegmentControl: JSTitleDataSource {

    // MARK: JSTitleDataSource
    func numberOfTitles() -> Int {
        return self.dataSourceCount
    }
    
    func title(_ title: JSTitleView, containerAt index: Int) -> JSTitleContainerView {
        guard let dataSource = self.dataSource else {
            fatalError("请实现 JSSegmentControlDataSource 协议")
        }
        return dataSource.segmentControl(self, titleAt: index)
    }
}

extension JSSegmentControl: JSTitleDelegate {

    // MARK: JSTitleDelegate
    func title(_ title: JSTitleView, didSelectAt index: Int) {
        self.contentView.selectedIndex(index)
        self.delegate?.segmentControl?(self, didSelectAt: index)
    }
    
    func title(_ title: JSTitleView, didDeselectAt index: Int) {
        self.delegate?.segmentControl?(self, didDeselectAt: index)
    }
}

extension JSSegmentControl: JSContentDataSource {

    // MARK: JSContentDataSource
    func numberOfContents() -> Int {
        return self.dataSourceCount
    }
    
    func content(_ content: JSContentView, containerAt index: Int) -> UIViewController {
        guard let dataSource = self.dataSource else {
            fatalError("请实现 JSSegmentControlDataSource 协议")
        }
        return dataSource.segmentControl(self, contentAt: index)
    }
}

extension JSSegmentControl: JSContentDelegate {

    // MARK: JSContentDelegate
    func contentSelectedAnimated(withProgress progress: CGFloat, from oldIndex: Int, to currentIndex: Int) {
        self.titleView.selectedIndexAnimated(withProgress: progress, fromOldIndex: oldIndex, toCurrentIndex: currentIndex)
    }
    
    func contentSelectedScrollAnimated(to currentIndex: Int) {
        self.titleView.selectedIndexScrollAnimated(toCurrentIndex: currentIndex)
    }
    
    func content(_ content: JSContentView, controllerWillAppear controller: UIViewController, at index: Int) {
        self.delegate?.segmentControl?(self, controllerWillAppear: controller, at: index)
    }
    
    func content(_ content: JSContentView, controllerDidAppear controller: UIViewController, at index: Int) {
        self.delegate?.segmentControl?(self, controllerDidAppear: controller, at: index)
    }
    
    func content(_ content: JSContentView, controllerWillDisappear controller: UIViewController, at index: Int) {
        self.delegate?.segmentControl?(self, controllerWillDisappear: controller, at: index)
    }
    
    func content(_ content: JSContentView, controllerDidDisappear controller: UIViewController, at index: Int) {
        self.delegate?.segmentControl?(self, controllerDidDisappear: controller, at: index)
    }
}

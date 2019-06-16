//
//  JSTitleView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSTitleView: UIView {

    // MARK: 属性
    weak var titleDataSource: JSTitleDataSource?
    weak var titleDelegate: JSTitleDelegate?
    
    private let style: JSSegmentControlStyle
    
    private var oldIndex: Int = 0
    private var currentIndex: Int = 0
    private var containerViews: [JSTitleContainerView] = [JSTitleContainerView]()
    
    private lazy var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.bounces = self.style.titleStyle.isTitleBounces
        scrollView.isScrollEnabled = self.style.titleStyle.isTitleScroll
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.clipsToBounds = false
        return scrollView
    }()

    private lazy var titleLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.titleStyle.lineColor
        return view
    }()
    
    private lazy var titleMask: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.titleStyle.maskColor
        view.layer.cornerRadius = self.style.titleStyle.maskCornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private var dataSourceCount: Int {
        get {
            return self.titleDataSource?.numberOfTitles() ?? 0
        }
    }
    
    // MARK: 初始化
    public init(frame: CGRect, segmentStyle style: JSSegmentControlStyle) {
        self.style = style
        super.init(frame: frame)
        self.setupTitleView()
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
    func dequeueReusableTitle(at index: Int) -> JSTitleContainerView? {
        guard (0..<self.containerViews.count).contains(index) else {
            return nil
        }
        return self.containerViews[index]
    }
    
    func reloadData() {
        self.titleScrollView.subviews.forEach { $0.removeFromSuperview() }
        self.containerViews.removeAll()
        
        self.oldIndex = 0
        self.currentIndex = 0
        
        self.setupSubviews()
        self.setNeedsUpdateConstraints()
        
        self.selectedIndexScrollAnimated(toCurrentIndex: 0)
    }
    
    func selectedIndex(_ index: Int) {
        guard index >= 0 && index < self.dataSourceCount else {
            fatalError("设置的下标不合法")
        }
        self.currentIndex = index
        self.selectedIndexAnimated(fromOldIndex: self.oldIndex, toCurrentIndex: self.currentIndex)
    }
    
    func selectedIndexAnimated(withProgress progress: CGFloat, fromOldIndex oldIndex: Int, toCurrentIndex currentIndex: Int) {
        guard oldIndex >= 0 && oldIndex < self.dataSourceCount else {
            return
        }
        guard currentIndex >= 0 && currentIndex < self.dataSourceCount else {
            return
        }
        
        let oldContainer = self.containerViews[oldIndex]
        let currentContainer = self.containerViews[currentIndex]
        
        let xDistance = currentContainer.frame.minX - oldContainer.frame.minX
        let widthDistance = currentContainer.frame.width - oldContainer.frame.width
        
        let lineWidth = self.style.titleStyle.lineWidth == 0.0 ? currentContainer.bounds.width : min(self.style.titleStyle.lineWidth, currentContainer.bounds.width)
        
        self.titleLine.frame.size.width = lineWidth
        self.titleLine.center.x = currentContainer.center.x
                
        self.containerViews[currentIndex].lineFrame = self.titleLine.frame
        
        let xLineDistance = currentContainer.lineFrame.minX - oldContainer.lineFrame.minX
        let widthLineDistance = currentContainer.lineFrame.width - oldContainer.lineFrame.width
        
        if self.style.titleStyle.isShowLines {
            self.titleLine.frame.origin.x = oldContainer.lineFrame.minX + xLineDistance * progress
            self.titleLine.frame.size.width = oldContainer.lineFrame.width + widthLineDistance * progress
        }
        if self.style.titleStyle.isShowMasks {
            self.titleMask.frame.origin.x = oldContainer.frame.minX + xDistance * progress
            self.titleMask.frame.size.width = oldContainer.frame.width + widthDistance * progress
        }
        if self.style.titleStyle.isTitleScale {
            let scaleDistance = self.style.titleStyle.maxTitleScale - 1.0
            oldContainer.scale = self.style.titleStyle.maxTitleScale - scaleDistance * progress
            currentContainer.scale = 1.0 + scaleDistance * progress
        }
    }
    
    func selectedIndexScrollAnimated(toCurrentIndex currentIndex: Int) {
        let margin = self.style.titleStyle.containerMargin

        let oldContainerView = self.containerViews[self.oldIndex]
        let currentContainerView = self.containerViews[currentIndex]
        
        oldContainerView.isSelected = false
        currentContainerView.isSelected = true
        
        if self.titleScrollView.contentSize.width != self.bounds.width + margin {
            var offSetX = currentContainerView.center.x - self.bounds.width * 0.5
            if offSetX < 0.0 {
                offSetX = 0.0
            }
            var maxOffSetX = self.titleScrollView.contentSize.width - self.bounds.width
            if maxOffSetX < 0.0 {
                maxOffSetX = 0.0
            }
            if offSetX > maxOffSetX {
                offSetX = maxOffSetX
            }
            self.titleScrollView.setContentOffset(CGPoint(x: offSetX, y: 0.0), animated: true)
        }
        
        self.titleDelegate?.title(self, didSelectAt: currentIndex)
        self.titleDelegate?.title(self, didDeselectAt: self.oldIndex)
        
        self.oldIndex = currentIndex
    }
    
    // MARK: 重写父类方法
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.makeConstraints()
        self.setupCurrentSelectScale()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let _ = newSuperview else {
            return
        }
        self.setupSubviews()
        self.setupCurrentSelect()
    }
    
    // MARK: 设置方法
    private func setupTitleView() {
        self.clipsToBounds = true
    }
    
    private func setupSubviews() {
        self.addSubview(self.titleScrollView)
        self.setupTitleContainer()
        self.setupTitleLineAndMask()
    }
    
    private func setupTitleLineAndMask() {
        if self.style.titleStyle.isShowLines {
            self.titleScrollView.addSubview(self.titleLine)
        }
        if self.style.titleStyle.isShowMasks {
            self.titleScrollView.insertSubview(self.titleMask, at: 0)
        }
    }
    
    private func setupTitleContainer() {
        for index in 0..<self.dataSourceCount {
            guard let containerView = self.titleDataSource?.title(self, containerAt: index) else {
                fatalError("请实现 JSTitleDataSource 协议")
            }
            containerView.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewPressed(_:)))
            containerView.addGestureRecognizer(tapGesture)
            self.containerViews.append(containerView)
            self.titleScrollView.addSubview(containerView)
        }
    }
    
    private func setupCurrentSelect() {
        guard (0..<self.containerViews.count).contains(self.currentIndex) else {
            return
        }
        let currentContainer = self.containerViews[self.currentIndex]
        currentContainer.isSelected = true
        self.titleDelegate?.title(self, didSelectAt: self.currentIndex)
    }
    
    private func setupCurrentSelectScale() {
        guard (0..<self.containerViews.count).contains(self.currentIndex) else {
            return
        }
        let currentContainer = self.containerViews[self.currentIndex]
        if self.style.titleStyle.isTitleScale {
            currentContainer.scale = self.style.titleStyle.maxTitleScale
        }
    }
    
    private func setupScrollContentSize() {
        let margin = self.style.titleStyle.containerMargin
        if self.style.titleStyle.isTitleScroll {
            if let lastContainerView = self.containerViews.last {
                self.titleScrollView.contentSize = CGSize(width: lastContainerView.frame.maxX + margin, height: 0.0)
            }
        }
    }
    
    // MARK: 私有方法
    private func makeConstraints() {
        self.makeTitleContainerConstraints()
        self.makeTitleLineAndMaskConstraints()
        self.setupScrollContentSize()
    }
    
    private func makeTitleLineAndMaskConstraints() {
        guard (0..<self.containerViews.count).contains(self.currentIndex) else {
            return
        }
        
        let currentContainer = self.containerViews[self.currentIndex]
        
        let lineWidth = self.style.titleStyle.lineWidth == 0.0 ? currentContainer.bounds.width : min(self.style.titleStyle.lineWidth, currentContainer.bounds.width)
        let lineHeight = self.style.titleStyle.lineHeight
        let maskHeight = self.style.titleStyle.maskHeight
        
        if self.style.titleStyle.isShowLines {
            self.titleLine.frame.origin.y = currentContainer.frame.maxY
            self.titleLine.frame.size = CGSize(width: lineWidth, height: lineHeight)
            self.titleLine.center.x = currentContainer.center.x
            
            self.containerViews[self.currentIndex].lineFrame = self.titleLine.frame
        }
        if self.style.titleStyle.isShowMasks {
            self.titleMask.frame.size = CGSize(width: currentContainer.bounds.width, height: maskHeight)
            self.titleMask.center = currentContainer.center
        }
    }
    
    private func makeTitleContainerConstraints() {
        if !self.style.titleStyle.isTitleScroll {
            var containerX: CGFloat = 0.0
            let containerY: CGFloat = 0.0
            let containerWidth: CGFloat = self.bounds.width / CGFloat(self.dataSourceCount)
            let containerHeight: CGFloat = self.bounds.height - self.style.titleStyle.lineHeight
            for index in 0..<self.dataSourceCount {
                containerX = CGFloat(index) * containerWidth
                self.containerViews[index].frame = CGRect(x: containerX, y: containerY, width: containerWidth, height: containerHeight)
            }
        }
        else {
            let margin = self.style.titleStyle.containerMargin
            var oldIndex: Int = 0
            for index in 0..<self.dataSourceCount {
                let currentContainer = self.containerViews[index]
                let oldContainer = self.containerViews[oldIndex]
                
                currentContainer.frame.origin.x = index == 0 ? margin : oldContainer.frame.maxX + margin
                currentContainer.frame.size = self.style.titleStyle.containerSize != .zero ?self.style.titleStyle.containerSize : currentContainer.containerSize
                currentContainer.center.y = self.bounds.height / 2.0
                
                oldIndex = index
            }
        }
    }
    
    private func selectedIndexAnimated(fromOldIndex oldIndex: Int, toCurrentIndex currentIndex: Int) {
        guard oldIndex != currentIndex else {
            return
        }
        
        let oldContainerView = (oldIndex < 0 || oldIndex >= self.dataSourceCount) ? nil : self.containerViews[oldIndex]
        let currentContainer = self.containerViews[currentIndex]
        
        let lineWidth = self.style.titleStyle.lineWidth == 0.0 ? currentContainer.bounds.width : min(self.style.titleStyle.lineWidth, currentContainer.bounds.width)
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.style.titleStyle.isTitleScale {
                oldContainerView?.scale = 1.0
                currentContainer.scale = self.style.titleStyle.maxTitleScale
            }
            if self.style.titleStyle.isShowLines {
                self.titleLine.frame.size.width = lineWidth
                self.titleLine.center.x = currentContainer.center.x

                self.containerViews[currentIndex].lineFrame = self.titleLine.frame
            }
            if self.style.titleStyle.isShowMasks {
                self.titleMask.frame.size.width = currentContainer.bounds.width
                self.titleMask.center.x = currentContainer.center.x
            }
        }, completion: { (_) in
            self.selectedIndexScrollAnimated(toCurrentIndex: currentIndex)
        })
    }
    
    // MARK: Tap Gesture Action
    @objc private func containerViewPressed(_ tapGesture: UITapGestureRecognizer) {
        guard let selectContainer = tapGesture.view as? JSTitleContainerView else {
            fatalError("请检查 tapGesture 所属的 View")
        }
        self.currentIndex = selectContainer.tag
        self.selectedIndexAnimated(fromOldIndex: self.oldIndex, toCurrentIndex: self.currentIndex)
    }
}

//
//  JSContentView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSContentView: UICollectionView {
    
    // MARK:
    private let style: ContentStyle
    
    private let identifier = "com.sibo.jian.segment.content"
    
    weak var contentDataSource: JSContentDataSource?
    weak var contentDelegate: JSContentDelegate?
    
    private weak var parent: UIViewController!
    
    private var pastIndex: Int = 0
    private var presentIndex: Int = 0
    private var isFirstLoading: Bool = true
    private var isForbidAdjustPosition: Bool = false
    private var isScrolledMorePage: Bool = false
    private var pastOffsetX: CGFloat = 0.0
    private var childControllers: [Int: UIViewController] = [Int: UIViewController]()
    
    // MARK:
    public init(style: ContentStyle, parent: UIViewController) {
        self.style = style
        self.parent = parent
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        self.configView()
        self.addNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeNotification()
        #if DEBUG
        let function = #function
        let file = #file.split(separator: "/").last ?? "null"
        let line = #line
        print(file, line, function)
        #endif
    }
    
    // MARK:
    public func reload() {
        self.childControllers.values.forEach { [unowned self] (childController) in
            self.removeChildController(childController)
        }
        
        self.childControllers.removeAll()
        
        self.pastIndex = 0
        self.presentIndex = 0
        self.isFirstLoading = true
        self.isForbidAdjustPosition = false
        self.isScrolledMorePage = false
        self.pastOffsetX = 0.0
        
        self.reloadData()
        
        self.selected(index: 0)
    }
    
    func dequeueReusableContent(at index: Int) -> UIViewController? {
        return self.childControllers[index]
    }
    
    func selected(index: Int) {
        guard index >= 0, index < self.numberOfItems(inSection: 0) else {
            return
        }
        
        self.isForbidAdjustPosition = true
        self.isScrolledMorePage = false
        
        self.pastIndex = self.presentIndex
        self.presentIndex = index
        
        let pages = labs(self.presentIndex - self.pastIndex)
        if pages >= 2 {
            self.isScrolledMorePage = true
        }
        
        let offsetX = CGFloat(index) * self.bounds.width
        
        self.setContentOffset(CGPoint(x: offsetX, y: 0.0), animated: !self.isScrolledMorePage)
    }
    
    // MAKR:
    private func configView() {
        guard !self.parent.shouldAutomaticallyForwardAppearanceMethods else {
            fatalError("请重写 \(self.parent.description) 的 shouldAutomaticallyForwardAppearanceMethods 函数，并返回 false")
        }
        
        self.backgroundColor = self.style.backgroundColor
        self.dataSource = self
        self.delegate = self
        self.bounces = self.style.isBouncesEnabled
        self.alwaysBounceHorizontal = true
        self.isPagingEnabled = true
        self.isScrollEnabled = self.style.isScrollEnabled
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configChildViewController(to containerView: UICollectionViewCell, forItemAt index: Int) {
        guard self.presentIndex == index else {
            return
        }
        
        var childController = self.childControllers[index]
        
        if childController == nil {
            childController = self.contentDataSource?.content(self, containerAt: index)
            self.childControllers[index] = childController
            self.presentIndex = index
        }
        
        if childController is UINavigationController {
            fatalError("禁止添加 UINavigationController 类型的控制器")
        }
        
        self.addChildController(childController, containerView: containerView)
        
        if self.isFirstLoading {
            self.willAppear(index: index)
            self.didAppear(index: index)
            self.isFirstLoading = false
        }
        else {
            if self.isForbidAdjustPosition, self.isScrolledMorePage {
                self.willDisappear(index: self.pastIndex)
                self.willAppear(index: self.presentIndex)
                self.didAppear(index: self.presentIndex)
                self.didDisappear(index: self.pastIndex)
            }
            else {
                self.willDisappear(index: self.pastIndex)
                self.willAppear(index: index)
            }
        }
    }
    
    // MARK:
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoryWarningMethod(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    private func addChildController(_ childController: UIViewController?, containerView: UICollectionViewCell) {
        guard let childController = childController else {
            return
        }
        self.parent.addChild(childController)
        childController.view.frame = containerView.contentView.bounds
        containerView.contentView.addSubview(childController.view)
        childController.didMove(toParent: self.parent)
    }
    
    private func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
    
    private func willAppear(index: Int) {
        if let controller = self.childControllers[index] {
            controller.beginAppearanceTransition(true, animated: false)
            self.contentDelegate?.content?(self, willAppear: controller, forItemAt: index)
        }
    }
    
    private func didAppear(index: Int) {
        if let controller = self.childControllers[index] {
            controller.endAppearanceTransition()
            self.contentDelegate?.content?(self, didAppear: controller, forItemAt: index)
        }
    }
    
    private func willDisappear(index: Int) {
        if let controller = self.childControllers[index] {
            controller.beginAppearanceTransition(false, animated: false)
            self.contentDelegate?.content?(self, willDisappear: controller, forItemAt: index)
        }
    }
    
    private func didDisappear(index: Int) {
        if let controller = self.childControllers[index] {
            controller.endAppearanceTransition()
            self.contentDelegate?.content?(self, didDisappear: controller, forItemAt: index)
        }
    }
    
    // MARK:
    @objc private func receiveMemoryWarningMethod(_ notification: Notification) {
        self.childControllers.forEach { (key, value) in
            if key != self.presentIndex {
                self.childControllers.removeValue(forKey: key)
                self.removeChildController(value)
            }
        }
    }
}

extension JSContentView: UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let contentDataSource = self.contentDataSource else {
            return 0
        }
        return contentDataSource.numberOfContents()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath)
        cell.contentView.backgroundColor = self.backgroundColor
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension JSContentView: UICollectionViewDelegate {
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.configChildViewController(to: cell, forItemAt: indexPath.item)
    }
    
    #warning("生命周期管理异常")
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !self.isForbidAdjustPosition {
            if self.pastIndex == indexPath.item {
                self.didAppear(index: self.presentIndex)
                self.didDisappear(index: indexPath.item)
            }
            else {
                let itemController = self.childControllers[indexPath.item]
                itemController?.beginAppearanceTransition(false, animated: false)
                let pastController = self.childControllers[self.pastIndex]
                pastController?.beginAppearanceTransition(true, animated: false)
                self.didAppear(index: self.pastIndex)
                self.didDisappear(index: indexPath.item)
            }
        }
        else {
            if !self.isScrolledMorePage {
                self.didAppear(index: self.presentIndex)
                self.didDisappear(index: self.pastIndex)
            }
        }
    }
}

extension JSContentView: UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension JSContentView: UIScrollViewDelegate {
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isForbidAdjustPosition || scrollView.contentOffset.x <= 0.0 || scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.width {
            return
        }
        
        let ratio = scrollView.contentOffset.x / scrollView.bounds.width
        
        let index = Int(ratio)
        let offsetXDistance = scrollView.contentOffset.x - self.pastOffsetX
        
        var progress: CGFloat = 0.0
        if offsetXDistance > 0.0 {
            progress = ratio - floor(ratio)
        }
        else if offsetXDistance < 0.0 {
            progress = 1.0 - (ratio - floor(ratio))
        }
        
        if offsetXDistance > 0.0 {
            if progress == 0.0 {
                return
            }
            self.presentIndex = index + 1
            self.pastIndex = index
        }
        else if offsetXDistance < 0.0 {
            self.presentIndex = index
            self.pastIndex = index + 1
        }
        else {
            return
        }
        
        self.contentDelegate?.content(selectedAnimation: progress, from: self.pastIndex, to: self.presentIndex)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pastOffsetX = scrollView.contentOffset.x
        self.isForbidAdjustPosition = false
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let presentIndex = Int(scrollView.contentOffset.x / self.bounds.width)
        if self.presentIndex != presentIndex {
            self.presentIndex = presentIndex
        }
        self.contentDelegate?.content(selected: presentIndex)
    }
}

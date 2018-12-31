//
//  JSContentView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSContentView: UIView {

    // MARK: 属性
    weak var contentDataSource: JSContentDataSource?
    weak var contentDelegate: JSContentDelegate?
    
    private let style: JSSegmentControlStyle
    private let identifier = "com.sibo.jian.content.container"
    
    private weak var parent: UIViewController?
    
    private var currentViewController: UIViewController?
    private var oldIndex: Int = 0
    private var currentIndex: Int = 0
    private var isFirstLoading: Bool = true
    private var isForbidAdjustPosition: Bool = false
    private var isScrolledMorePage: Bool = false
    private var oldOffsetX: CGFloat = 0.0
    private var childViewControllers: [Int: UIViewController] = [Int: UIViewController]()
    
    private lazy var contentCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.contentLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = self.style.contentStyle.isContentBounces
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = self.style.contentStyle.isContentScroll
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        return collectionView
    }()
    
    private lazy var contentLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private var dataSourceCount: Int {
        return self.contentDataSource?.numberOfContents() ?? 0
    }

    // MARK: 初始化
    public init(frame: CGRect, segmentStyle style: JSSegmentControlStyle, parentViewController parent: UIViewController) {
        self.style = style
        self.parent = parent
        super.init(frame: frame)
        self.setupContentView()
        self.addNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeNotification()
        #if DEBUG
        print("DEINIT: \(#file)")
        #endif
    }
    
    // MARK: 公开方法
    func dequeueReusableContent(at index: Int) -> UIViewController? {
        guard self.childViewControllers.keys.contains(index) else {
            return nil
        }
        return self.childViewControllers[index]
    }
    
    func selectedIndex(_ index: Int) {
        guard index >= 0 && index < self.dataSourceCount else {
            fatalError("设置的下标不合法")
        }
        
        self.isForbidAdjustPosition = true
        self.isScrolledMorePage = false
        
        self.oldIndex = self.currentIndex
        self.currentIndex = index
        
        let offSetX = CGFloat(index) * self.contentCollectionView.bounds.width
        
        let page = labs(self.currentIndex - self.oldIndex)
        if page >= 2 {
            self.isScrolledMorePage = true
        }
        
        self.contentCollectionView.setContentOffset(CGPoint(x: offSetX, y: 0.0), animated: !self.isScrolledMorePage)
    }

    func reloadData() {
        for (_, value) in self.childViewControllers {
            JSContentView.removeChildViewController(value)
        }
        self.childViewControllers.removeAll()
        
        self.oldIndex = 0
        self.currentIndex = 0
        self.isFirstLoading = true
        self.isForbidAdjustPosition = false
        self.oldOffsetX = 0.0
        
        self.contentCollectionView.reloadData()
        self.selectedIndex(0)
    }
    
    class func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
    
    // MARK: 重写父类方法
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let currentViewController = self.currentViewController {
            currentViewController.view.frame = self.bounds
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let _ = newSuperview else {
            return
        }
        self.setupSubviews()
    }

    // MARK: 设置方法
    private func setupContentView() {
        guard !self.parent!.shouldAutomaticallyForwardAppearanceMethods else {
            fatalError("请重写 \(self.parent.self!) 的 shouldAutomaticallyForwardAppearanceMethods 函数，并返回 false")
        }
    }
    
    private func setupSubviews() {
        self.addSubview(self.contentCollectionView)
    }
    
    private func setupChildViewController(to cell: UICollectionViewCell, atIndex index: Int) {
        guard self.currentIndex == index else {
            return
        }
        
        self.currentViewController = self.childViewControllers[index]
        
        if self.currentViewController == nil {
            guard let contentDataSource = self.contentDataSource else {
                fatalError("请实现 JSContentDataSource 协议")
            }
            self.currentViewController = contentDataSource.content(self, containerAt: index)
            self.childViewControllers[index] = self.currentViewController
            self.currentIndex = index
        }
        
        if self.currentViewController?.isKind(of: UINavigationController.self) ?? false {
            fatalError("禁止添加 UINavigationController 类型的控制器")
        }
        
        self.parent?.addChildViewController(self.currentViewController!)
        self.currentViewController?.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(self.currentViewController!.view)
        self.currentViewController?.didMove(toParentViewController: self.parent)
        
        if self.isFirstLoading {
            self.willAppearAtIndex(index)
            self.didAppearAtIndex(index)
            self.isFirstLoading = false
        }
        else {
            self.willAppearAtIndex(index)
            self.willDisappearAtIndex(self.oldIndex)
        }
    }
    
    // MARK: 私有方法
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoryWarningHandle(_:)), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    private func willAppearAtIndex(_ index: Int) {
        if let controller = self.childViewControllers[index] {
            controller.beginAppearanceTransition(true, animated: false)
            self.contentDelegate?.content?(self, controllerWillAppear: controller, at: index)
        }
    }
    
    private func didAppearAtIndex(_ index: Int) {
        if let controller = self.childViewControllers[index] {
            controller.endAppearanceTransition()
            self.contentDelegate?.content?(self, controllerDidAppear: controller, at: index)
        }
    }
    
    private func willDisappearAtIndex(_ index: Int) {
        if let controller = self.childViewControllers[index] {
            controller.beginAppearanceTransition(false, animated: false)
            self.contentDelegate?.content?(self, controllerWillDisappear: controller, at: index)
        }
    }
    
    private func didDisappearAtIndex(_ index: Int) {
        if let controller = self.childViewControllers[index] {
            controller.endAppearanceTransition()
            self.contentDelegate?.content?(self, controllerDidDisappear: controller, at: index)
        }
    }

    // MARK: Notification Action
    @objc private func receiveMemoryWarningHandle(_ notification: Notification) {
        for (index, value) in self.childViewControllers {
            if index != self.currentIndex {
                self.childViewControllers.removeValue(forKey: index)
                JSContentView.removeChildViewController(value)
            }
        }
    }
}

extension JSContentView: UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath)
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
        self.setupChildViewController(to: cell, atIndex: indexPath.row)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !self.isForbidAdjustPosition {
            if self.currentIndex == indexPath.row {
                let oldViewController = self.childViewControllers[self.oldIndex]
                oldViewController?.beginAppearanceTransition(true, animated: false)
                let currentViewController = self.childViewControllers[indexPath.row]
                currentViewController?.beginAppearanceTransition(false, animated: false)
                self.didAppearAtIndex(self.oldIndex)
                self.didDisappearAtIndex(indexPath.row)
            }
            else {
                if self.oldIndex == indexPath.row {
                    self.didAppearAtIndex(self.currentIndex)
                    self.didDisappearAtIndex(indexPath.row)
                }
                else {
                    let oldViewController = self.childViewControllers[self.oldIndex]
                    oldViewController?.beginAppearanceTransition(true, animated: false)
                    let currentViewController = self.childViewControllers[indexPath.row]
                    currentViewController?.beginAppearanceTransition(false, animated: false)
                    self.didAppearAtIndex(self.oldIndex)
                    self.didDisappearAtIndex(indexPath.row)
                }
            }
        }
        else {
            if self.isScrolledMorePage {
                if labs(self.currentIndex - indexPath.row) == 1 {
                    self.didAppearAtIndex(self.currentIndex)
                    self.didDisappearAtIndex(self.oldIndex)
                }
            }
            else {
                self.didDisappearAtIndex(self.oldIndex)
                self.didAppearAtIndex(self.currentIndex)
            }
        }
    }
}

extension JSContentView: UIScrollViewDelegate {
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isForbidAdjustPosition ||
           scrollView.contentOffset.x <= 0.0 ||
           scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.width {
            return
        }
        
        let ratio = scrollView.contentOffset.x / self.bounds.width
        
        let index = Int(ratio)
        var progress = ratio - floor(ratio)
        
        let deltaX = scrollView.contentOffset.x - self.oldOffsetX
        
        if deltaX > 0.0 {
            if progress == 0.0 {
                return
            }
            self.currentIndex = index + 1
            self.oldIndex = index
        }
        else if deltaX < 0.0 {
            progress = 1.0 - progress
            self.currentIndex = index
            self.oldIndex = index + 1
        }
        else {
            return
        }
        
        self.contentDelegate?.contentSelectedAnimated(withProgress: progress, from: self.oldIndex, to: self.currentIndex)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / self.bounds.width)
        self.contentDelegate?.contentSelectedAnimated(withProgress: 1.0, from: currentIndex, to: currentIndex)
        self.contentDelegate?.contentSelectedScrollAnimated(to: currentIndex)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.oldOffsetX = scrollView.contentOffset.x
        self.isForbidAdjustPosition = false
    }
}

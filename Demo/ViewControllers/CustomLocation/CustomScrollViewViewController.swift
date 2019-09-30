//
//  CustomScrollViewViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/26.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class CustomScrollView: UIScrollView {
    
}

extension CustomScrollView: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer is UIPanGestureRecognizer) && (otherGestureRecognizer is UIPanGestureRecognizer)
    }
}

class CustomScrollViewViewController: UIViewController {

    // MARK:
    var scrollView: CustomScrollView?
    var headerView: UIView?
    var segmentControl: JSSegmentControl?
    var childScrollView: UIScrollView?
    
    var dataSource: [(CustomSegmentTitleDataSource, CustomSegmentChildViewControllerDataSource)] = [
        (.title("关注"), .tableChild), (.title("头条"), .collectionChild), (.title("视频"), .tableChild), (.title("娱乐"), .collectionChild),
        (.title("体育"), .tableChild), (.title("新时代"), .collectionChild), (.title("要闻"), .tableChild), (.title("段子"), .collectionChild),
        (.title("知否"), .tableChild), (.title("上海"), .collectionChild), (.title("公开课"), .tableChild), (.title("圈子"), .collectionChild),
        (.title("财经"), .tableChild), (.title("科技"), .collectionChild), (.title("汽车"), .tableChild), (.title("网易号"), .collectionChild)
    ]
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constructView()
        self.constructViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.constructNavigationBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    override var automaticallyAdjustsScrollViewInsets: Bool {
        set {
            super.automaticallyAdjustsScrollViewInsets = newValue
        }
        get {
            return false
        }
    }
    
    override var edgesForExtendedLayout: UIRectEdge {
        set {
            super.edgesForExtendedLayout = newValue
        }
        get {
            return UIRectEdge(rawValue: 0)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.makeViewConstraints()
    }
    
    // MARK:
    private func constructView() {
        self.scrollView = CustomScrollView()
        self.scrollView?.backgroundColor = UIColor.white
        self.scrollView?.alwaysBounceVertical = true
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.delegate = self
        if #available(iOS 11.0, *) {
            self.scrollView?.contentInsetAdjustmentBehavior = .never
        }
        self.scrollView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView!)
        
        self.headerView = UIView()
        self.headerView?.backgroundColor = UIColor.orange
        self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView?.addSubview(self.headerView!)
        
        var titleStyle = TitleStyle()
        titleStyle.isLineHidden = false
        titleStyle.isAdjustMaskAndLineSize = false
        titleStyle.spacing = 10.0
        titleStyle.lineWidth = 40.0
        titleStyle.lineHeight = 3.0
        titleStyle.lineColor = UIColor.red
        titleStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)
        
        var titleContainerStyle = TitleContainerStyle()
        titleContainerStyle.titleFont = UIFont.boldSystemFont(ofSize: 16.0)
        titleContainerStyle.titleTextColor = UIColor.black
        titleContainerStyle.titleHighlightedTextColor = UIColor.red
        titleContainerStyle.badgeEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 8.0)
        titleContainerStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)

        let contentStyle = ContentStyle()
        
        self.segmentControl = JSSegmentControl(titleStyle: titleStyle, titleContainerStyle: titleContainerStyle, contentStyle: contentStyle, parent: self)
        
        self.scrollView?.addSubview(self.segmentControl!.titleView)
        self.scrollView?.addSubview(self.segmentControl!.contentView)
        
        self.view.needsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    // MARK:
    private func constructViewController() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func constructNavigationBar() {
        self.navigationItem.title = "Custom Scroll View"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MAKR:
    private func makeViewConstraints() {
        guard let strongScrollView = self.scrollView, let strongHeaderView = self.headerView, let strongSegmentControl = self.segmentControl else {
            return
        }
        
        let scrollViewLeading = strongScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let scrollViewTop = strongScrollView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let scrollViewTrailing = strongScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let scrollViewBottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            scrollViewBottom = strongScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        }
        else {
            scrollViewBottom = strongScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        NSLayoutConstraint.activate([scrollViewLeading, scrollViewTop, scrollViewTrailing, scrollViewBottom])
        
        let headerViewLeading = strongHeaderView.leadingAnchor.constraint(equalTo: strongScrollView.leadingAnchor)
        let headerViewTop = strongHeaderView.topAnchor.constraint(equalTo: strongScrollView.topAnchor)
        let headerViewTrailing = strongHeaderView.trailingAnchor.constraint(equalTo: strongScrollView.trailingAnchor)
        let headerViewWidth = strongHeaderView.widthAnchor.constraint(equalTo: strongScrollView.widthAnchor)
        let headerViewHeight = strongHeaderView.heightAnchor.constraint(equalToConstant: 250.0)
        NSLayoutConstraint.activate([headerViewLeading, headerViewTop, headerViewTrailing, headerViewWidth, headerViewHeight])
        
        let titleViewLeading = strongSegmentControl.titleView.leadingAnchor.constraint(equalTo: strongScrollView.leadingAnchor)
        let titleViewTop = strongSegmentControl.titleView.topAnchor.constraint(equalTo: strongHeaderView.bottomAnchor)
        let titleViewTrailing = strongSegmentControl.titleView.trailingAnchor.constraint(equalTo: strongScrollView.trailingAnchor)
        NSLayoutConstraint.activate([titleViewLeading, titleViewTop, titleViewTrailing])
        
        let contentViewLeading = strongSegmentControl.contentView.leadingAnchor.constraint(equalTo: strongScrollView.leadingAnchor)
        let contentViewTop = strongSegmentControl.contentView.topAnchor.constraint(equalTo: strongSegmentControl.titleView.bottomAnchor)
        let contentViewTrailing = strongSegmentControl.contentView.trailingAnchor.constraint(equalTo: strongScrollView.trailingAnchor)
        let contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: strongScrollView.bottomAnchor)
        let contentViewHeight = strongSegmentControl.contentView.heightAnchor.constraint(equalTo: strongScrollView.heightAnchor)
        NSLayoutConstraint.activate([contentViewLeading, contentViewTop, contentViewTrailing, contentViewBottom, contentViewHeight])
    }
}

extension CustomScrollViewViewController: UIScrollViewDelegate {
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let strongHeaderView = self.headerView,
            let strongTitleView = self.segmentControl?.titleView,
            let strongChildScrollView = self.childScrollView else
        {
            return
        }
        
        if strongChildScrollView.contentOffset.y > 0.0 {
            scrollView.contentOffset.y = strongHeaderView.bounds.height + strongTitleView.bounds.height
        }
    }
}

extension CustomScrollViewViewController: JSSegmentControlDataSource {
    
    // MARK: JSSegmentControlDataSource
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        title.title = self.dataSource[index].0.title
        return title
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        var content = segmentControl.dequeueReusableContent(at: index)
        if content == nil {
            content = self.dataSource[index].1.viewController
            if content is UIScrollViewDelegate {
                if let collectionChild = content as? CollectionChildViewController {
                    collectionChild.childScrollDelegate = self
                }
                else if let tableChild = content as? TableChildViewController {
                    tableChild.childScrollDelegate = self
                }
            }
        }
        return content!
    }
}

extension CustomScrollViewViewController: JSSegmentControlDelegate {
    
    // MARK: JSSegmentControlDelegate
    func segmentControl(_ segmentControl: JSSegmentControl, didSelectAt index: Int) {
        print("Did Select At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didDeselectAt index: Int) {
        print("Did Deselect At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, willAppear controller: UIViewController, forItemAt index: Int) {
        print("Will Appear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didAppear controller: UIViewController, forItemAt index: Int) {
        print("Did Appear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, willDisappear controller: UIViewController, forItemAt index: Int) {
        print("Will Disappear At \(index)")
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, didDisappear controller: UIViewController, forItemAt index: Int) {
        print("Did Disappear At \(index)")
    }
}

extension CustomScrollViewViewController: ChildScrollViewDelegate {
    
    // MARK: ChildScrollViewDelegate
    func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
        self.childScrollView = childScrollView
        
        guard let strongScrollView = self.scrollView, let strongHeaderView = self.headerView, let strongTitleView = self.segmentControl?.titleView else {
            return
        }
        
        if strongScrollView.contentOffset.y < strongHeaderView.bounds.height + strongTitleView.bounds.height {
            childScrollView.contentOffset = CGPoint.zero
        }
        else {
            strongScrollView.contentOffset = CGPoint(x: 0.0, y: strongHeaderView.bounds.height + strongTitleView.bounds.height)
        }
    }
}

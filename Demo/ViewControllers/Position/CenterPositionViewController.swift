//
//  CenterPositionViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/25.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class CenterPositionViewController: UIViewController {

    // MARK:
    var segmentControl: JSSegmentControl?
    
    var dataSource: [(CustomSegmentTitleDataSource, CustomSegmentImageDataSource, CustomSegmentImageDataSource, CustomSegmentChildViewControllerDataSource)] = [
        (.title("向左看"), .image("segment_background_normal"), .highlightedImage("segment_background_selected"), .tableChild),
        (.title("向右看"), .image("segment_background_normal"), .highlightedImage("segment_background_selected"), .buttonChild)
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
        var titleStyle = TitleStyle()
        titleStyle.isForceEqualContainerSize = true
        titleStyle.spacing = 10.0
        titleStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: -5.0, right: -10.0)
        
        var titleContainerStyle = TitleContainerStyle()
        titleContainerStyle.position = .center
        titleContainerStyle.spacing = 4.0
        titleContainerStyle.titleFont = UIFont.boldSystemFont(ofSize: 16.0)
        titleContainerStyle.titleTextColor = UIColor.black
        titleContainerStyle.titleHighlightedTextColor = UIColor.white
        
        var contentStyle = ContentStyle()
        contentStyle.isScrollEnabled = false
        
        self.segmentControl = JSSegmentControl(titleStyle: titleStyle, titleContainerStyle: titleContainerStyle, contentStyle: contentStyle, parent: self)
        
        self.view.addSubview(self.segmentControl!.titleView)
        self.view.addSubview(self.segmentControl!.contentView)
    }
    
    // MARK:
    private func constructViewController() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func constructNavigationBar() {
        self.navigationItem.title = "Center Position"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MAKR:
    private func makeViewConstraints() {
        guard let strongSegmentControl = self.segmentControl else {
            return
        }
        
        let titleViewLeading = strongSegmentControl.titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let titleViewTop = strongSegmentControl.titleView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let titleViewTrailing = strongSegmentControl.titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let titleViewBottom = strongSegmentControl.titleView.bottomAnchor.constraint(equalTo: strongSegmentControl.contentView.topAnchor)
        NSLayoutConstraint.activate([titleViewLeading, titleViewTop, titleViewTrailing, titleViewBottom])
        
        let contentViewLeading = strongSegmentControl.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let contentViewTrailing = strongSegmentControl.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let contentViewBottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        }
        else {
            contentViewBottom = strongSegmentControl.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        NSLayoutConstraint.activate([contentViewLeading, contentViewTrailing, contentViewBottom])
    }
}

extension CenterPositionViewController: JSSegmentControlDataSource {
    
    // MARK: JSSegmentControlDataSource
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        title.title = self.dataSource[index].0.title
        title.image = UIImage(named: self.dataSource[index].1.name)
        title.highlightedImage = UIImage(named: self.dataSource[index].2.name)
        return title
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        var content = segmentControl.dequeueReusableContent(at: index)
        if content == nil {
            content = self.dataSource[index].3.viewController
        }
        return content!
    }
}

extension CenterPositionViewController: JSSegmentControlDelegate {
    
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

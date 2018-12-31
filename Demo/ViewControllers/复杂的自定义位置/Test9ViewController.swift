//
//  Test9ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/21.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class Test9ViewController: UIViewController {

    // MAKR:
    var dataSource = ["新闻头条", "国际要闻", "体育", "中国足球", "汽车", "囧途旅游", "幽默搞笑", "视频", "无厘头", "美女图片", "今日房价", "头像",]
    var childScrollView: UIScrollView?
    
    lazy var style: JSSegmentControlStyle = {
        var style = JSSegmentControlStyle()
        style.titleContainerStyle.titleTextColor = UIColor.red
        style.titleContainerStyle.titleHighlightedTextColor = UIColor.white
        
        style.titleStyle.isShowMasks = true
        style.titleStyle.maskColor = UIColor.orange.withAlphaComponent(0.5)

        return style
    }()

    lazy var segment: JSSegmentControl = JSSegmentControl(segmentStyle: self.style)
    lazy var titleView = JSTitleView(frame: CGRect(origin: .zero, size: CGSize(width: SCREEN_WIDTH, height: 50.0)), segmentStyle: self.style)
    lazy var contentView = JSContentView(frame: CGRect(origin: .zero, size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN - 50.0)), segmentStyle: self.style, parentViewController: self)
    
    lazy var tableView: Test9TableView = {
        let tableView = Test9TableView(frame: CGRect(x: 0.0, y: TOP_MARGIN, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN), style: .grouped)
        tableView.tableHeaderView = self.tableHeaderView
        tableView.tableFooterView = UIView()
        tableView.rowHeight = self.contentView.bounds.height
        tableView.sectionHeaderHeight = 50.0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        return tableView
    }()
    
    lazy var tableHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: 150.0))
        view.backgroundColor = UIColor.green
        return view
    }()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        
        self.segment.dataSource = self
        self.segment.delegate = self
        
        self.segment.configuration(titleView: self.titleView, contentView: self.contentView)
    }

    // MAKR:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
}

extension Test9ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(self.contentView)
        return cell
    }
}

extension Test9ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.titleView
    }
}

extension Test9ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let childScrollView = self.childScrollView else {
            return
        }
        if childScrollView.contentOffset.y > 0.0 {
            self.tableView.contentOffset = CGPoint(x: 0.0, y: 150.0)
        }
        let offSetY = scrollView.contentOffset.y
        if offSetY < 150.0 {
            childScrollView.contentOffset = .zero
        }
    }
}

extension Test9ViewController: JSSegmentControlDataSource {

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

        if index % 2 == 0 {
            if content == nil {
                content = Test9TableViewController()
                (content as? Test9TableViewController)?.scrollDelegate = self
            }
        }
        else {
            if content == nil {
                content = Test9CollectionViewController(nibName:"Test9CollectionViewController", bundle:nil)
                (content as? Test9CollectionViewController)?.scrollDelegate = self
            }
        }

        return content!
    }
}

extension Test9ViewController: JSSegmentControlDelegate {

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

extension Test9ViewController: ChildScrollViewDelegate {
    
    func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
        self.childScrollView = childScrollView
        if self.tableView.contentOffset.y < 150.0 {
            childScrollView.contentOffset = .zero
        }
        else {
            self.tableView.contentOffset = CGPoint(x: 0.0, y: 150.0)
        }
    }
}

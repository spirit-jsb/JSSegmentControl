//
//  Test7ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/20.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import JSSegmentControl

class Test7ViewController: UIViewController {

    // MAKR:
    var dataSource = [["title": "全部",
                       "normal_image": "parcels_all_normal",
                       "selected_image": "parcels_all_selected",
                       "color": "parcels_all_selected_color"],
                      ["title": "待取件",
                       "normal_image": "parcels_pickup_normal",
                       "selected_image": "parcels_pickup_selected",
                       "color": "parcels_pickup_selected_color"],
                      ["title": "待投递",
                       "normal_image": "parcels_dropOff_normal",
                       "selected_image": "parcels_dropOff_selected",
                       "color": "parcels_dropOff_selected_color"],
                      ["title": "待收货",
                       "normal_image": "parcels_receipt_normal",
                       "selected_image": "parcels_receipt_selected",
                       "color": "parcels_receipt_selected_color"],
                      ["title": "运送中",
                       "normal_image": "parcels_transit_normal",
                       "selected_image": "parcels_transit_selected",
                       "color": "parcels_transit_selected_color"],
                      ["title": "已送达",
                       "normal_image": "parcels_served_normal",
                       "selected_image": "parcels_served_selected",
                       "color": "parcels_served_selected_color"],
                      ["title": "已取消",
                       "normal_image": "parcels_voided_normal",
                       "selected_image": "parcels_voided_selected",
                       "color": "parcels_voided_selected_color"]]

    var titleContainerStyle = TitleContainerStyle()
    var titleStyle = TitleStyle()
    var contentStyle = ContentStyle()
    
    lazy var titleView = JSTitleView(style: self.titleStyle)
    lazy var contentView = JSContentView(style: self.contentStyle, parent: self)
    let segmentControl = JSSegmentControl()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleContainerStyle.titleFont = UIFont.systemFont(ofSize: 15.0)
        self.titleContainerStyle.titleTextColor = UIColor.blue
        self.titleContainerStyle.titleHighlightedTextColor = UIColor.red
        self.titleContainerStyle.position = .top
        
        self.titleStyle.isAdjustMaskAndLineSize = false
        self.titleStyle.isLineHidden = false
        self.titleStyle.isAdjustContainerSize = false
        self.titleStyle.containerWidth = 65.0
        self.titleStyle.containerHeight = 65.0
        self.titleStyle.spacing = 10.0
        self.titleStyle.lineWidth = 45.0
        self.titleStyle.lineHeight = 3.0
        self.titleStyle.lineColor = UIColor.yellow
        self.titleStyle.edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)
        
        self.view.addSubview(self.titleView)
        self.view.addSubview(self.contentView)
        
        self.segmentControl.title = titleView
        self.segmentControl.content = contentView
        self.segmentControl.dataSource = self
        self.segmentControl.delegate = self
    }
    
    // MAKR:
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
            else {
                make.top.equalTo(self.view).offset(TOP_MARGIN)
            }
            make.bottom.equalTo(self.contentView.snp.top)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    // MAKR:
    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dataSource = self.dataSource.reversed()
        self.segmentControl.reload()
    }
}

extension Test7ViewController: JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        var title = segmentControl.dequeueReusableTitle(at: index)
        if title == nil {
            title = JSTitleContainerView(style: self.titleContainerStyle)
        }
        
        title?.title = self.dataSource[index]["title"]
        title?.image = UIImage(named: self.dataSource[index]["normal_image"]!)
        title?.highlightedImage = UIImage(named: self.dataSource[index]["selected_image"]!)
        if #available(iOS 11.0, *) {
            title?.highlightedTextColor = UIColor(named: self.dataSource[index]["color"]!)
        } else {
            // Fallback on earlier versions
        }
        title?.badge = index
        return title!
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        var content = segmentControl.dequeueReusableContent(at: index)
        
        if index % 3 == 0 {
            if content == nil {
                content = Child1ViewController()
            }
        }
        else if index % 3 == 1 {
            if content == nil {
                content = Child2ViewController()
            }
        }
        else {
            if content == nil {
                content = Child3ViewController()
            }
        }
        
        return content!
    }
}

extension Test7ViewController: JSSegmentControlDelegate {
    
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

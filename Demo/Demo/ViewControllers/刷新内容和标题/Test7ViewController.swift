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
                       "selected_image": "parcels_all_selected"],
                      ["title": "待取件",
                       "normal_image": "parcels_pickup_normal",
                       "selected_image": "parcels_pickup_selected"],
                      ["title": "待投递",
                       "normal_image": "parcels_dropOff_normal",
                       "selected_image": "parcels_dropOff_selected"],
                      ["title": "待收货",
                       "normal_image": "parcels_receipt_normal",
                       "selected_image": "parcels_receipt_selected"],
                      ["title": "运送中",
                       "normal_image": "parcels_transit_normal",
                       "selected_image": "parcels_transit_selected"],
                      ["title": "已送达",
                       "normal_image": "parcels_served_normal",
                       "selected_image": "parcels_served_selected"],
                      ["title": "已取消",
                       "normal_image": "parcels_voided_normal",
                       "selected_image": "parcels_voided_selected"]]
    var style = JSSegmentControlStyle()
    lazy var segment = JSSegmentControl(frame: CGRect(x: 0.0, y: TOP_MARGIN, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN), segmentStyle: self.style, parentViewController: self)
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.style.titleContainerStyle.position = .top
        self.style.titleContainerStyle.titleTextColor = UIColor.blue
        self.style.titleContainerStyle.titleHighlightedTextColor = UIColor.red
        
        self.style.titleStyle.isShowLines = true
        self.style.titleStyle.titleHeight = 70.0
        self.style.titleStyle.containerSize = CGSize(width: 65.0, height: 65.0)
        self.style.titleStyle.lineColor = UIColor.orange
        
        self.segment.dataSource = self
        self.segment.delegate = self
        self.view.addSubview(self.segment)
    }
    
    // MAKR:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    // MAKR:
    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dataSource = self.dataSource.reversed()
        self.segment.reloadData()
    }
}

extension Test7ViewController: JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return self.dataSource.count
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        let title = segmentControl.dequeueReusableTitle(at: index)
        title.segmentTitle = self.dataSource[index]["title"]
        title.segmentImage = UIImage(named: self.dataSource[index]["normal_image"]!)
        title.segmentHighlightedImage = UIImage(named: self.dataSource[index]["selected_image"]!)
        title.segmentBadge = index
        return title
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

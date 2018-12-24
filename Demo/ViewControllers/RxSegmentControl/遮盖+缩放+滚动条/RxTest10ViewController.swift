//
//  RxTest10ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/23.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import JSSegmentControl
import RxSwift
import RxCocoa

struct SegmentTemplateModel: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case title
        case image
        case highlightedImage
        case action
        case badge
    }
    
    var title: String
    var image: String
    var highlightedImage: String
    var action: String
    var badge: Int
}

struct RxTest10SegmentCustomData {
    
    // MARK: 属性
    var items: [Item]
}

extension RxTest10SegmentCustomData: SegmentModelType {
    
    // MARK: SegmentModelType
    typealias Item = SegmentTemplateModel
    
    init(original: RxTest10SegmentCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

class RxTest10ViewController: UIViewController {

    // MAKR:
    private lazy var style: JSSegmentControlStyle = {
        var style = JSSegmentControlStyle()
        style.titleContainerStyle.titleTextColor = UIColor.blue
        style.titleContainerStyle.titleHighlightedTextColor = UIColor.red
        style.titleStyle.isShowLines = true
        style.titleStyle.isShowMasks = true
        style.titleStyle.isTitleScale = true
        style.titleStyle.lineColor = UIColor.orange
        style.titleStyle.maskColor = UIColor.orange.withAlphaComponent(0.5)
        return style
    }()
    
    lazy var segment: JSSegmentControl = JSSegmentControl(frame: CGRect(x: 0.0, y: TOP_MARGIN, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN), segmentStyle: self.style, parentViewController: self)
    
    private var dataSource: RxSegmentReloadDataSource<RxTest10SegmentCustomData>!
    private var bag: DisposeBag = DisposeBag()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.segment)
    
        var segmentDataSource: Observable<RxTest10SegmentCustomData>
        
        let jsonPath = Bundle.main.path(forResource: "SegmentTemplate", ofType: "json")
        let jsonURL = URL(fileURLWithPath: jsonPath ?? "")

        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let segmentTemplateModels = try JSONDecoder().decode([SegmentTemplateModel].self, from: jsonData)
            segmentDataSource = Observable.just(segmentTemplateModels)
                .map({ (items) -> RxTest10SegmentCustomData in
                    return RxTest10SegmentCustomData(items: items)
                })
        }
        catch {
            segmentDataSource = Observable.empty()
        }
        
        self.dataSource = RxSegmentReloadDataSource<RxTest10SegmentCustomData>(configureTitle: {
            (ds, sc, i, item) -> JSTitleContainerView in
            let title = sc.dequeueReusableTitle(at: i)
            title.segmentTitle = item.title
            title.segmentBadge = item.badge
            return title
        }, configureContent: {
            (ds, sc, i, item) -> UIViewController in
            var content = sc.dequeueReusableContent(at: i)
            if content == nil {
                if i % 3 == 0 {
                    content = Child1ViewController()
                }
                else if i % 3 == 1 {
                    content = Child2ViewController()
                }
                else {
                    content = Child3ViewController()
                }
            }
            return content!
        })
        
        self.segment.rx.setDelegate(self)
            .disposed(by: self.bag)
        
        segmentDataSource.bind(to: self.segment.rx.item(dataSource: self.dataSource))
            .disposed(by: self.bag)
    }
    
    // MAKR:
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
}

extension RxTest10ViewController: JSSegmentControlDelegate {
    
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

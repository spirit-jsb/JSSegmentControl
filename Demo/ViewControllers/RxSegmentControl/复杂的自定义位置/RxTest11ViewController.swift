//
//  RxTest11ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/24.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import JSSegmentControl
import RxSwift
import RxCocoa

struct RxTest11SegmentModel {

    var title: Observable<String>
    var image: Observable<UIImage?>
    var highlightedImage: Observable<UIImage?>
    var action: Observable<String>
    var badge: Observable<Int>
    
    init(_ template: SegmentTemplateModel) {
        self.title = Observable<String>.just(template.title)
        self.image = Observable<UIImage?>.just(UIImage(named: template.image))
        self.highlightedImage = Observable<UIImage?>.just(UIImage(named: template.highlightedImage))
        self.action = Observable<String>.just(template.action)
        self.badge = Observable<Int>.just(template.badge)
    }
}

struct RxTest11SegmentCustomData {

    // MARK: 属性
    var items: [Item]
}

extension RxTest11SegmentCustomData: SegmentModelType {

    // MARK: SegmentModelType
    typealias Item = RxTest11SegmentModel

    init(original: RxTest11SegmentCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

class RxTest11ViewController: UIViewController {
    
    // MAKR:
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
    
    lazy var tableView: RxTest11TableView = {
        let tableView = RxTest11TableView(frame: CGRect(x: 0.0, y: TOP_MARGIN, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_MARGIN), style: .grouped)
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
    
    private var dataSource: RxSegmentReloadDataSource<RxTest11SegmentCustomData>!
    private var bag: DisposeBag = DisposeBag()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
   
        var segmentDataSource: Observable<RxTest11SegmentCustomData>
        
        let jsonPath = Bundle.main.path(forResource: "SegmentTemplate", ofType: "json")
        let jsonURL = URL(fileURLWithPath: jsonPath ?? "")
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let models = try JSONDecoder().decode([SegmentTemplateModel].self, from: jsonData)
            let items = models.map({ (template) -> RxTest11SegmentModel in
                return RxTest11SegmentModel(template)
            })
            let customData = RxTest11SegmentCustomData(items: items)
            segmentDataSource = Observable<RxTest11SegmentCustomData>.just(customData)
        }
        catch {
            segmentDataSource = Observable.empty()
        }
        
        // ⚠️注意事项：configuration 函数请置于 DataSource 设置之前。⚠️
        self.segment.configuration(titleView: self.titleView, contentView: self.contentView)
        
        self.dataSource = RxSegmentReloadDataSource<RxTest11SegmentCustomData>(configureTitle: {
            (ds, sc, i, item) -> JSTitleContainerView in
            let title = sc.dequeueReusableTitle(at: i)
            item.title.bind(to: title.rx.title)
                .disposed(by: title.bag)
            item.badge.bind(to: title.rx.badge)
                .disposed(by: title.bag)
            return title
        }, configureContent: {
            [unowned self] (ds, sc, i, item) -> UIViewController in
            var content = sc.dequeueReusableContent(at: i)
            if content == nil {
                if i % 2 == 0 {
                    content = RxTest11TableViewController()
                    (content as? RxTest11TableViewController)?.scrollDelegate = self
                }
                else {
                    content = RxTest11CollectionViewController(nibName:"RxTest11CollectionViewController", bundle:nil)
                    (content as? RxTest11CollectionViewController)?.scrollDelegate = self
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

extension RxTest11ViewController: UITableViewDataSource {
    
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

extension RxTest11ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.titleView
    }
}

extension RxTest11ViewController: UIScrollViewDelegate {
    
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

extension RxTest11ViewController: JSSegmentControlDelegate {
    
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

extension RxTest11ViewController: ChildScrollViewDelegate {
    
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

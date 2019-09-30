//
//  ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/6.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

protocol ChildScrollViewDelegate: NSObjectProtocol {
    func childScrollViewDidScroll(_ childScrollView: UIScrollView)
}

enum DemoRow {
    case line
    case mask
    case lineAndMask
    case dotBadge
    case numberBadge
    case leftPosition
    case topPosition
    case rightPosition
    case bottomPosition
    case centerPosition
    case reload
    case defaultIndex
    case customTitleView
    case customTableView
    case customScrollView
    
    var title: String {
        switch self {
        case .line: return "Line"
        case .mask: return "Mask"
        case .lineAndMask: return "Line&Mask"
        case .dotBadge: return "Dot Badge"
        case .numberBadge: return "Number Badge"
        case .leftPosition: return "Left Position"
        case .topPosition: return "Top Position"
        case .rightPosition: return "Right Position"
        case .bottomPosition: return "Bottom Position"
        case .centerPosition: return "Center Position"
        case .reload: return "Reload"
        case .defaultIndex: return "Default Index"
        case .customTitleView: return "Custom Title View"
        case .customTableView: return "Custom Table View"
        case .customScrollView: return "Custom Scroll View"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .line: return LineViewController()
        case .mask: return MaskViewController()
        case .lineAndMask: return LineAndMaskViewController()
        case .dotBadge: return DotBadgeViewController()
        case .numberBadge: return NumberBadgeViewController()
        case .leftPosition: return LeftPositionViewController()
        case .topPosition: return TopPositionViewController()
        case .rightPosition: return RightPositionViewController()
        case .bottomPosition: return BottomPositionViewController()
        case .centerPosition: return CenterPositionViewController()
        case .reload: return ReloadViewController()
        case .defaultIndex: return DefaultIndexViewController()
        case .customTitleView: return CustomTitleViewViewController()
        case .customTableView: return CustomTableViewViewController()
        case .customScrollView: return CustomScrollViewViewController()
        }
    }
}

class ViewController: UIViewController {
    
    // MARK:
    private let identifier = "com.sibo.jian.segment.demo.tableview"
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource: [[DemoRow]] = [
        [.line, .mask, .lineAndMask],
        [.dotBadge, .numberBadge],
        [.leftPosition, .topPosition, .rightPosition, .bottomPosition, .centerPosition],
        [.reload],
        [.defaultIndex],
        [.customTitleView, .customTableView, .customScrollView]
    ]
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = self.dataSource[indexPath.section][indexPath.row].title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
}

extension ViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(self.dataSource[indexPath.section][indexPath.row].viewController, animated: true)
    }
}

//
//  CustomDataSource.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2019/9/24.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

enum CustomSegmentTitleDataSource {
    case title(String)
}

extension CustomSegmentTitleDataSource {
    
    var title: String {
        switch self {
        case .title(let value):
            return value
        }
    }
}

enum CustomSegmentImageDataSource {
    case image(String)
    case highlightedImage(String)
}

extension CustomSegmentImageDataSource {
    
    var name: String {
        switch self {
        case .image(let value), .highlightedImage(let value):
            return value
        }
    }
}

enum CustomSegmentChildViewControllerDataSource {
    case buttonChild
    case child
    case collectionChild
    case tableChild
}

extension CustomSegmentChildViewControllerDataSource {
    
    var viewController: UIViewController {
        switch self {
        case .buttonChild: return UIStoryboard(name: "Child", bundle: nil).instantiateViewController(withIdentifier: "ButtonChildViewController")
        case .child: return UIStoryboard(name: "Child", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController")
        case .collectionChild: return UIStoryboard(name: "Child", bundle: nil).instantiateViewController(withIdentifier: "CollectionChildViewController")
        case .tableChild: return UIStoryboard(name: "Child", bundle: nil).instantiateViewController(withIdentifier: "TableChildViewController")
        }
    }
}

enum CustomSegmentBadgeDataSource {
    case badge(Int)
}

extension CustomSegmentBadgeDataSource {
    
    var badge: Int {
        switch self {
        case .badge(let value):
            return value
        }
    }
}

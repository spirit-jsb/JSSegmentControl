//
//  SegmentModelType.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

public protocol SegmentModelType {
    
    associatedtype Item
    
    var items: [Item] { get }
    
    init(items: [Item])
}

//
//  SegmentModel.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

public struct SegmentModel<ItemType> {
    
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension SegmentModel: SegmentModelType {
    
    public typealias Item = ItemType
    
    public init(original: SegmentModel<ItemType>, items: [ItemType]) {
        self = original
        self.items = items
    }
}

extension SegmentModel: CustomStringConvertible {
    
    public var description: String {
        return "\(self.items)"
    }
}

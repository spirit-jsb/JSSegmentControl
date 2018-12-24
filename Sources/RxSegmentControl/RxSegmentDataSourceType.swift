//
//  RxSegmentDataSourceType.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol RxSegmentDataSourceType {
    
    associatedtype Element
    
    func segmentControl(_ segmentControl: JSSegmentControl, observedEvent: Event<Element>) -> Void
}

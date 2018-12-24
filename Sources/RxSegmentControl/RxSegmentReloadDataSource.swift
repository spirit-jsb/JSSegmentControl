//
//  RxSegmentReloadDataSource.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class RxSegmentReloadDataSource<S: SegmentModelType>: SegmentDataSource<S>, RxSegmentDataSourceType {

    public typealias Element = S
    
    open func segmentControl(_ segmentControl: JSSegmentControl, observedEvent: Event<S>) {
        Binder(self) { dataSource, element in
            #if DEBUG
            self._dataSourceBound = true
            #endif
            dataSource.setSegment(element)
            segmentControl.reloadData()
        }
        .on(observedEvent)
    }
}

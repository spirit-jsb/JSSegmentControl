//
//  SegmentDataSource.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class SegmentDataSource<S: SegmentModelType>: NSObject, JSSegmentControlDataSource {
    
    public typealias I = S.Item
    
    public typealias ConfigureTitle = (SegmentDataSource<S>, JSSegmentControl, Int, I) -> JSTitleContainerView
    public typealias ConfigureContent = (SegmentDataSource<S>, JSSegmentControl, Int, I) -> UIViewController
    
    public init(configureTitle: @escaping ConfigureTitle, configureContent: @escaping ConfigureContent) {
        self.configureTitle = configureTitle
        self.configureContent = configureContent
    }
    
    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    var _dataSourceBound: Bool = false
    
    private func ensureNotMutatedAfterBinding() {
        assert(!self._dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }
    #endif
    
    private var _segmentModel: SegmentModel<I> = SegmentModel<I>(items: [])
    
    open var segmentModel: SegmentModel<I> {
        return self._segmentModel
    }
    
    open subscript(index: Int) -> I {
        set(item) {
            self._segmentModel.items[index] = item
        }
        get {
            return self._segmentModel.items[index]
        }
    }
    
    open func setSegment(_ segment: S) {
        self._segmentModel = SegmentModel<I>(items: segment.items)
    }
    
    open var configureTitle: ConfigureTitle {
        didSet {
            #if DEBUG
            self.ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var configureContent: ConfigureContent {
        didSet {
            #if DEBUG
            self.ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    // MARK: JSSegmentControlDataSource
    open func numberOfSegments() -> Int {
        return self._segmentModel.items.count
    }
    
    open func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        precondition(index < self._segmentModel.items.count)
        return self.configureTitle(self, segmentControl, index, self[index])
    }
    
    open func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        precondition(index < self._segmentModel.items.count)
        return self.configureContent(self, segmentControl, index, self[index])
    }
}

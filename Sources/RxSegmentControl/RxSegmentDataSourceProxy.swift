//
//  RxSegmentDataSourceProxy.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension JSSegmentControl: HasDataSource {
    public typealias DataSource = JSSegmentControlDataSource
}

let segmentDataSourceNotSet = SegmentDataSourceNotSet()

final class SegmentDataSourceNotSet: NSObject, JSSegmentControlDataSource {
    
    func numberOfSegments() -> Int {
        return 0
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        fatalError("DataSource not set", file: #file, line: #line)
    }
    
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        fatalError("DataSource not set", file: #file, line: #line)
    }
}

open class RxSegmentDataSourceProxy: DelegateProxy<JSSegmentControl, JSSegmentControlDataSource>, DelegateProxyType, JSSegmentControlDataSource {
    
    /// Typed parent object.
    public weak private(set) var segment: JSSegmentControl?
    
    /// - parameter segment: Parent object for delegate proxy.
    public init(segment: JSSegmentControl) {
        self.segment = segment
        super.init(parentObject: segment, delegateProxy: RxSegmentDataSourceProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxSegmentDataSourceProxy(segment: $0) }
    }
    
    fileprivate weak var _requiredMethodsDataSource: JSSegmentControlDataSource? = segmentDataSourceNotSet
    
    // MARK: JSSegmentControlDataSource
    
    /// Required delegate method implementation.
    public func numberOfSegments() -> Int {
        return (self._requiredMethodsDataSource ?? segmentDataSourceNotSet).numberOfSegments()
    }
    
    /// Required delegate method implementation.
    public func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView {
        return (self._requiredMethodsDataSource ?? segmentDataSourceNotSet).segmentControl(segmentControl, titleAt: index)
    }
    
    /// Required delegate method implementation.
    public func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController {
        return (self._requiredMethodsDataSource ?? segmentDataSourceNotSet).segmentControl(segmentControl, contentAt: index)
    }
    
    /// For more information take a look at `DelegateProxyType`.
    open override func setForwardToDelegate(_ delegate: JSSegmentControlDataSource?, retainDelegate: Bool) {
        self._requiredMethodsDataSource = delegate ?? segmentDataSourceNotSet
        super.setForwardToDelegate(delegate, retainDelegate: retainDelegate)
    }
}

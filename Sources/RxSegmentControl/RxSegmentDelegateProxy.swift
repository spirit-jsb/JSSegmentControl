//
//  RxSegmentDelegateProxy.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/22.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

///// For more information take a look at `DelegateProxyType`.
open class RxSegmentDelegateProxy: DelegateProxy<JSSegmentControl, JSSegmentControlDelegate>, DelegateProxyType, JSSegmentControlDelegate {
    
    /// Typed parent object.
    public weak private(set) var segment: JSSegmentControl?
    
    /// - parameter segment: Parent object for delegate proxy.
    public init(segment: JSSegmentControl) {
        self.segment = segment
        super.init(parentObject: segment, delegateProxy: RxSegmentDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxSegmentDelegateProxy(segment: $0) }
    }
        
    public static func currentDelegate(for object: JSSegmentControl) -> JSSegmentControlDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: JSSegmentControlDelegate?, to object: JSSegmentControl) {
        object.delegate = delegate
    }
}

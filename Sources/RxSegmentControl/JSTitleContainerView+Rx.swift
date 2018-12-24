//
//  JSTitleContainerView+Rx.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/24.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: JSTitleContainerView {
        
    public var title: Binder<String?> {
        return Binder(self.base) { (titleContainer, title) in
            titleContainer.segmentTitle = title
        }
    }
    
    public var highlightedTextColor: Binder<UIColor?> {
        return Binder(self.base) { (titleContainer, highlightedTextColor) in
            titleContainer.segmentTitleHighlightedTextColor = highlightedTextColor
        }
    }
    
    public var image: Binder<UIImage?> {
        return Binder(self.base) { (titleContainer, image) in
            titleContainer.segmentImage = image
        }
    }
    
    public var highlightedImage: Binder<UIImage?> {
        return Binder(self.base) { (titleContainer, highlightedImage) in
            titleContainer.segmentHighlightedImage = highlightedImage
        }
    }
    
    public var badge: Binder<Int> {
        return Binder(self.base) { (titleContainer, badge) in
            titleContainer.segmentBadge = badge
        }
    }
    
    public var isSelected: Binder<Bool> {
        return Binder(self.base) { (titleContainer, isSelected) in
            titleContainer.isSelected = isSelected
        }
    }
}

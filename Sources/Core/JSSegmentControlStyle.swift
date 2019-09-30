//
//  JSSegmentControlStyle.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public enum TitleImagePosition {
    case left       // 文字在左侧, 图片在右侧
    case top        // 文字在上侧, 图片在下侧
    case right      // 文字在右侧, 图片在左侧
    case bottom     // 文字在下侧, 图片在上侧
    case center     // 图片被设置为背景图片
}

public enum BadgeStyle {
    case dot        // 不显示数字信息
    case number     // 显示数字信息
}

public struct TitleStyle {
    
    /// 是否隐藏 mask view，默认值为 true
    public var isMaskHidden: Bool = true
    
    /// 是否隐藏 line view，默认值为 true
    public var isLineHidden: Bool = true
    
    /// 是否开启缩放效果，默认值为 false
    public var isZoomEnabled: Bool = false
    
    /// 是否开启滚动效果，默认值为 true
    public var isScrollEnabled: Bool = true
    
    /// 是否开启弹性效果，默认值为 true
    public var isBouncesEnabled: Bool = true
    
    /// edge insets, 默认值为 UIEdgeInsets.zero
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 是否强制平分 container 尺寸，默认值为 false
    ///
    /// - Warning: 当 isForceEqualContainerSize 设置为 true 时，container 强制平分宽度，无视其他属性设置。
    public var isForceEqualContainerSize: Bool = false
    
    /// 是否自适应调整 container 尺寸，默认值为 true
    ///
    /// - Warning: 当 isAdjustContainerSize 设置为 false 时，container 的尺寸遵循 containerWidth & containerHeight
    public var isAdjustContainerSize: Bool = true
    
    /// 是否自适应调整 mask 和 line 尺寸，默认值为 true
    ///
    /// - Warning: 当 isAdjustMaskAndLineSize 设置为 false 时，line & mask 的尺寸遵循 lineWidth/lineHeight & maskWidth/maskHeight
    public var isAdjustMaskAndLineSize: Bool = true
    
    /// container width, 默认值为 0.0
    public var containerWidth: CGFloat = 0.0
    
    /// container height, 默认值为 0.0
    public var containerHeight: CGFloat = 0.0
    
    /// title view 中 container 间间隔, 默认值为 0.0
    public var spacing: CGFloat = 0.0
    
    /// mask width, 默认值为 0.0
    public var maskWidth: CGFloat = 0.0
    
    /// mask height, 默认值为 0.0
    public var maskHeight: CGFloat = 0.0
    
    /// mask color, 默认值为 nil
    public var maskColor: UIColor? = nil
    
    /// line width, 默认值为 0.0
    public var lineWidth: CGFloat = 0.0
    
    /// line height, 默认值为 0.0
    public var lineHeight: CGFloat = 0.0
    
    /// line color, 默认值为 nil
    public var lineColor: UIColor? = nil
    
    public init() {
        
    }
}

public struct TitleContainerStyle {
    
    /// 最大缩放倍数，默认值为 1.15
    public var maximumZoomScale: CGFloat = 1.15
    
    /// 标题容器中文字的字体, 默认值为 nil
    public var titleFont: UIFont? = nil
    
    /// 标题容器中文字的默认颜色, 默认值为 nil
    public var titleTextColor: UIColor? = nil
    
    /// 标题容器中文字的高亮颜色, 默认值为 nil
    public var titleHighlightedTextColor: UIColor? = nil
    
    /// 标题容器中 Badge 是否隐藏, 默认值为 true
    public var isBadgeHidden: Bool = true
    
    /// 标题容器中 Badge 背景颜色, 默认值为 nil
    public var badgeBackgroundColor: UIColor? = nil
    
    /// 标题容器中 Badge 样式, 默认值为 BadgeStyle.dot
    public var badgeStyle: BadgeStyle = .dot
    
    /// 标题容器中 Badge 文字颜色, 默认值为 nil
    public var badgeTextColor: UIColor? = nil
    
    /// 标题容器中 Badge 边框颜色, 默认值为 nil
    public var badgeBorderColor: CGColor? = nil
    
    /// 标题容器中 Badge 边框宽度, 默认值为 0.5
    public var badgeBorderWidth: CGFloat = 0.5
    
    /// badge edge insets, 默认值为 UIEdgeInsets.zero
    public var badgeEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 标题容器中文字、图像位置, 默认值为 TitleImagePosition.left
    public var position: TitleImagePosition = .left
    
    /// edge insets, 默认值为 UIEdgeInsets.zero
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 标题容器中文字、图像间间隔, 默认值为 0.0
    public var spacing: CGFloat = 0.0
    
    public init() {
        
    }
}

public struct ContentStyle {
    
    /// 是否开启滚动效果，默认值为 true
    public var isScrollEnabled: Bool = true
    
    /// 是否开启弹性效果，默认值为 true
    public var isBouncesEnabled: Bool = true
    
    public init() {
        
    }
}


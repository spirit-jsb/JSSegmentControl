//
//  JSSegmentControlStyle.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

public enum TitleAndImagePosition: Int {
    case left        // 文字在左侧, 图片在右侧
    case top         // 文字在上侧, 图片在下侧
    case right       // 文字在右侧, 图片在左侧
    case bottom      // 文字在下侧, 图片在上侧
    case background  // 图片被设置为背景图片
}

public struct JSSegmentControlStyle {

    // MARK: JSTitleContainerStyle
    public struct JSTitleContainerStyle {
        
        /// 标题容器中文字的字体, 默认值为 UIFont.systemFont(ofSize: 14.0)
        public var titleFont: UIFont = UIFont.systemFont(ofSize: 14.0)
        
        /// 标题容器中文字的默认颜色, 默认值为 UIColor.clear
        public var titleTextColor: UIColor = UIColor.clear
        
        /// 标题容器中文字的高亮颜色, 默认值为 UIColor.clear
        public var titleHighlightedTextColor: UIColor = UIColor.clear
        
        /// 标题容器中 Badge 是否隐藏, 默认值为 true
        public var hiddenBadge: Bool = true
        
        /// 标题容器中 Badge 背景的默认颜色, 默认值为 UIColor.white
        public var badgeBackgroundColor: UIColor = UIColor.white
        
        /// 标题容器中 Badge 文字的字体, 默认值为 UIFont.boldSystemFont(ofSize: 10.0)
        public var badgeFont: UIFont = UIFont.boldSystemFont(ofSize: 10.0)
        
        /// 标题容器中 Badge 文字的默认颜色, 默认值为 UIColor.red
        public var badgeTextColor: UIColor = UIColor.red
        
        /// 标题容器中 Badge 边框的默认颜色, 默认值为 UIColor.red
        public var badgeBorderColor: UIColor = UIColor.red
        
        /// 标题容器中 Badge 文字的默认偏移量, 默认值为 8.0
        public var badgeOffset: CGFloat = 8.0
        
        /// 标题容器中文字、图像位置, 默认值为 .left
        public var position: TitleAndImagePosition = .left
        
        /// 标题容器中固定间隔, 默认值为 4.0
        public var margin: CGFloat = 4.0
    }
    
    // MARK: JSTitleStyle
    public struct JSTitleStyle {
        
        /// 是否显示遮罩, 默认值为 false
        public var isShowMasks: Bool = false
        
        /// 是否显示滚动条, 默认值为 false
        public var isShowLines: Bool = false
        
        /// TitleView 是否可以缩放, 默认值为 false
        public var isTitleScale: Bool = false

        /// TitleView 是否可以滚动, 默认值为 true
        public var isTitleScroll: Bool = true
        
        /// TitleView 是否具有弹性效果, 默认值为 true
        public var isTitleBounces: Bool = true
        
        /// TitleView 最大缩放倍数, 默认值为 1.15
        public var maxTitleScale: CGFloat = 1.15
        
        /// TitleView 的默认高度
        public var titleHeight: CGFloat = 44.0

        /// 遮罩高度, 默认值为 28.0
        public var maskHeight: CGFloat = 28.0
        
        /// 遮罩颜色, 默认值为 UIColor.clear
        public var maskColor: UIColor = UIColor.clear
        
        /// 遮罩裁剪半径, 默认值为 14.0
        public var maskCornerRadius: CGFloat = 14.0
        
        /// 滚动条高度, 默认值为 2.0
        public var lineHeight: CGFloat = 2.0
        
        /// 滚动条颜色, 默认值为 UIColor.clear
        public var lineColor: UIColor = UIColor.clear
        
        /// 标题容器间距, 默认值为 12.0
        public var containerMargin: CGFloat = 12.0
        
        /// 标题容器大小, 默认值为 .zero
        public var containerSize: CGSize = .zero
    }
    
    // MARK: JSContentStyle
    public struct JSContentStyle {
        
        /// ContentView 是否可以滚动, 默认值为 true
        public var isContentScroll: Bool = true
        
        /// ContentView 是否具有弹性效果, 默认值为 true
        public var isContentBounces: Bool = true
    }
    
    // MARK: 公开属性
    public var titleContainerStyle: JSTitleContainerStyle = JSTitleContainerStyle()
    public var titleStyle: JSTitleStyle = JSTitleStyle()
    public var contentStyle: JSContentStyle = JSContentStyle()
    
    // MAKR: 初始化
    public init() {
        
    }
}

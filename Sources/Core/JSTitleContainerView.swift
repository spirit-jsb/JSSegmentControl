//
//  JSTitleContainerView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSTitleContainerView: UIView {

    // MARK: 属性
    public var segmentTitle: String? {
        willSet {
            self.segmentTitleLabel.text = newValue
            self.segmentTitleLabel.sizeToFit()
        }
    }
    
    public var segmentTitleHighlightedTextColor: UIColor? {
        willSet {
            self.segmentTitleLabel.highlightedTextColor = newValue
        }
    }
    
    public var segmentImage: UIImage? {
        willSet {
            self.segmentImageView.image = newValue
            self.segmentImageView.sizeToFit()
        }
    }

    public var segmentHighlightedImage: UIImage? {
        willSet {
            self.segmentImageView.highlightedImage = newValue
            self.segmentImageView.sizeToFit()
        }
    }

    public var segmentBadge: Int = 0 {
        willSet {
            if newValue == 0 {
                self.segmentBadgeLabel.isHidden = true
            }
            else {
                self.segmentBadgeLabel.text = "\(newValue)"
                self.segmentBadgeLabel.sizeToFit()
            }
        }
    }
    
    public var isSelected: Bool = false {
        willSet {
            self.segmentTitleLabel.isHighlighted = newValue
            self.segmentImageView.isHighlighted = newValue
        }
    }
    
    var scale: CGFloat = 1.0 {
        willSet {
            self.transform = CGAffineTransform(scaleX: newValue, y: newValue)
        }
    }
    
    var containerSize: CGSize {
        let margin = self.style.margin
        
        let imageViewSize = self.segmentImageView.bounds.size
        let labelSize = self.segmentTitleLabel.bounds.size
        
        let imageViewWidth = imageViewSize.width
        let imageViewHeight = imageViewSize.height
        
        let labelWidth = labelSize.width
        let labelHeight = labelSize.height
        
        var maxWidth: CGFloat = 0.0
        var maxHeight: CGFloat = 0.0
        
        switch self.style.position {
        case .left, .right:
            maxWidth = imageViewWidth + labelWidth + margin
            maxHeight = max(imageViewHeight, labelHeight)
        case .top, .bottom:
            maxWidth = max(imageViewWidth, labelWidth)
            maxHeight = imageViewHeight + labelHeight + margin
        case .background:
            maxWidth = max(imageViewWidth, labelWidth)
            maxHeight = max(imageViewHeight, labelHeight)
        }
        return CGSize(width: maxWidth + 2.0 * margin, height: maxHeight + 2.0 * margin)
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    private lazy var segmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var segmentTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = self.style.titleFont
        label.textColor = self.style.titleTextColor
        label.textAlignment = .center
        label.highlightedTextColor = self.style.titleHighlightedTextColor
        return label
    }()
    
    private lazy var segmentBadgeLabel: UILabel = {
        let label = UILabel()
        label.isHidden = self.style.hiddenBadge
        label.backgroundColor = self.style.badgeBackgroundColor
        label.font = self.style.badgeFont
        label.textColor = self.style.badgeTextColor
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.masksToBounds = true
        label.layer.borderColor = self.style.badgeBorderColor.cgColor
        label.layer.borderWidth = 0.5
        return label
    }()

    private let style: JSSegmentControlStyle.JSTitleContainerStyle
    
    // MARK: 初始化
    public init(style: JSSegmentControlStyle.JSTitleContainerStyle) {
        self.style = style
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("DEINIT: \(#file)")
        #endif
    }
    
    // MARK: 重写父类方法
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.makeConstraints()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let _ = newSuperview else {
            return
        }
        self.setupSubviews()
    }
    
    // MARK: 设置方法
    private func setupSubviews() {
        self.addSubview(self.containerView)
        
        self.containerView.insertSubview(self.segmentImageView, at: 0)
        self.containerView.insertSubview(self.segmentTitleLabel, at: 1)
        self.containerView.insertSubview(self.segmentBadgeLabel, at: 2)
    }

    // MARK: 私有方法
    private func makeConstraints() {
        self.containerView.bounds.size = self.containerSize
        
        switch self.style.position {
        case .left, .right:
            self.horizontalConstraints(withPosition: self.style.position)
        case .top, .bottom:
            self.verticalConstraints(withPosition: self.style.position)
        case .background:
            self.backgroundConstraints()
        }
        self.badgeConstraints()
    }
    
    private func horizontalConstraints(withPosition position: TitleAndImagePosition) {
        let margin = self.style.margin
        let containerCenterY = self.containerView.bounds.height / 2.0
        
        switch position {
        case .left:
            self.segmentImageView.frame.origin.x = margin
            self.segmentTitleLabel.frame.origin.x = self.segmentImageView.frame.maxX + margin
        case .right:
            self.segmentTitleLabel.frame.origin.x = margin
            self.segmentImageView.frame.origin.x = self.segmentTitleLabel.frame.maxX + margin
        default:
            break
        }
        self.segmentImageView.center.y = containerCenterY
        self.segmentTitleLabel.center.y = containerCenterY
        self.containerView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    }
    
    private func verticalConstraints(withPosition position: TitleAndImagePosition) {
        let margin = self.style.margin
        let containerCenterX = self.containerView.bounds.width / 2.0
        
        switch position {
        case .top:
            self.segmentImageView.frame.origin.y = margin
            self.segmentTitleLabel.frame.origin.y = self.segmentImageView.frame.maxY + margin
        case .bottom:
            self.segmentTitleLabel.frame.origin.y = margin
            self.segmentImageView.frame.origin.y = self.segmentTitleLabel.frame.maxY + margin
        default:
            break
        }
        self.segmentImageView.center.x = containerCenterX
        self.segmentTitleLabel.center.x = containerCenterX
        self.containerView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    }
    
    private func backgroundConstraints() {
        let containerCenter = CGPoint(x: self.containerView.bounds.width / 2.0, y: self.containerView.bounds.height / 2.0)
        
        self.segmentImageView.center = containerCenter
        self.segmentTitleLabel.center = containerCenter
        self.containerView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    }
    
    private func badgeConstraints() {
        let margin: CGFloat = 16.0
        let badgeOffset: CGFloat = self.style.badgeOffset
        
        self.segmentBadgeLabel.frame.size = CGSize(width: margin, height: margin)
        self.segmentBadgeLabel.center = CGPoint(x: self.containerView.bounds.maxX - badgeOffset, y: self.containerView.bounds.minY + badgeOffset)
    }
}

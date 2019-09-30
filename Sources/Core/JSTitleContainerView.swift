//
//  JSTitleContainerView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

#warning("Zoomed 导致 Badge 部分被裁减")
public class JSTitleContainerView: UIView {
    
    // MARK: 属性
    private let titleContainerStyle: TitleContainerStyle
    
    private let imageView: UIImageView = UIImageView()
    private let titleView: UILabel = UILabel()
    private let badgeView: UIView = UIView()
    private let badgeContainerLabel: UILabel = UILabel()
    private let containerView: UIStackView = UIStackView()
    
    public var title: String? {
        willSet {
            self.titleView.text = newValue
        }
    }
    
    public var image: UIImage? {
        willSet {
            self.imageView.image = newValue
            self.imageView.highlightedImage = newValue
        }
    }
    
    public var highlightedImage: UIImage? {
        willSet {
            self.imageView.highlightedImage = newValue
        }
    }
    
    public var textColor: UIColor? {
        willSet {
            self.titleView.textColor = newValue
            self.titleView.highlightedTextColor = newValue
        }
    }
    
    public var highlightedTextColor: UIColor? {
        willSet {
            self.titleView.highlightedTextColor = newValue
        }
    }
    
    public var badge: Int = 0 {
        willSet {
            self.badgeView.isHidden = self.titleContainerStyle.isBadgeHidden ? true : newValue == 0
            if self.titleContainerStyle.badgeStyle == .number {
                self.badgeContainerLabel.text = "\(newValue)"
            }
        }
    }
    
    var isSelected: Bool = false {
        willSet {
            self.titleView.isHighlighted = newValue
            self.imageView.isHighlighted = newValue
        }
    }
    
    var isZoomed: Bool = false {
        willSet {
            let scale = newValue ? self.titleContainerStyle.maximumZoomScale : 1.0
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    // MARK:
    public init(titleContainerStyle: TitleContainerStyle) {
        self.titleContainerStyle = titleContainerStyle
        
        super.init(frame: .zero)
        
        self.constructView(titleContainerStyle: titleContainerStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugLog()
    }
    
    // MARK:
    private func constructView(titleContainerStyle: TitleContainerStyle) {
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.backgroundColor = self.backgroundColor
        self.imageView.contentMode = .center
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false

        self.titleView.backgroundColor = self.backgroundColor
        self.titleView.textColor = titleContainerStyle.titleTextColor
        self.titleView.highlightedTextColor = titleContainerStyle.titleHighlightedTextColor
        self.titleView.textAlignment = .center
        self.titleView.font = titleContainerStyle.titleFont
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.badgeView.backgroundColor = titleContainerStyle.badgeBackgroundColor
        self.badgeView.isHidden = titleContainerStyle.isBadgeHidden
        self.badgeView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.badgeView)
        
        self.badgeContainerLabel.backgroundColor = UIColor.clear
        self.badgeContainerLabel.isHidden = titleContainerStyle.badgeStyle == .dot
        self.badgeContainerLabel.textColor = titleContainerStyle.badgeTextColor
        self.badgeContainerLabel.textAlignment = .center
        self.badgeContainerLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        self.badgeContainerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.badgeView.addSubview(self.badgeContainerLabel)
        
        self.containerView.distribution = .fillProportionally
        self.containerView.alignment = .center
        self.containerView.spacing = titleContainerStyle.spacing
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
        
        switch titleContainerStyle.position {
        case .left:
            self.containerView.axis = .horizontal
            self.containerView.addArrangedSubview(self.titleView)
            self.containerView.addArrangedSubview(self.imageView)
        case .right:
            self.containerView.axis = .horizontal
            self.containerView.addArrangedSubview(self.imageView)
            self.containerView.addArrangedSubview(self.titleView)
        case .top:
            self.containerView.axis = .vertical
            self.containerView.addArrangedSubview(self.titleView)
            self.containerView.addArrangedSubview(self.imageView)
        case .bottom:
            self.containerView.axis = .vertical
            self.containerView.addArrangedSubview(self.imageView)
            self.containerView.addArrangedSubview(self.titleView)
        case .center:
            self.addSubview(self.imageView)
            self.addSubview(self.titleView)
        }
        
        switch titleContainerStyle.position {
        case .center:
            self.makeCenterPositionConstraints(titleContainerStyle: titleContainerStyle)
        default:
            self.makeDefaultPositionConstraints(titleContainerStyle: titleContainerStyle)
        }
        self.makeBadgeConstraints(titleContainerStyle: titleContainerStyle)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.setLayerAttributes()
    }
    
    // MARK: 私有方法
    private func makeCenterPositionConstraints(titleContainerStyle: TitleContainerStyle) {
        let imageLeading = self.imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: titleContainerStyle.edgeInsets.left)
        let imageTop = self.imageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: titleContainerStyle.edgeInsets.top)
        let imageTrailing = self.imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: titleContainerStyle.edgeInsets.right)
        let imageBottom = self.imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: titleContainerStyle.edgeInsets.bottom)
        let imageCenterX = self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let imageCenterY = self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([imageLeading, imageTop, imageTrailing, imageBottom, imageCenterX, imageCenterY])
        
        let titleLeading = self.titleView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: titleContainerStyle.edgeInsets.left)
        let titleTop = self.titleView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: titleContainerStyle.edgeInsets.top)
        let titleTrailing = self.titleView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: titleContainerStyle.edgeInsets.right)
        let titleBottom = self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: titleContainerStyle.edgeInsets.bottom)
        let titleCenterX = self.titleView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let titleCenterY = self.titleView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([titleLeading, titleTop, titleTrailing, titleBottom, titleCenterX, titleCenterY])
    }
    
    private func makeDefaultPositionConstraints(titleContainerStyle: TitleContainerStyle) {
        let containerLeading = self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleContainerStyle.edgeInsets.left)
        let containerTop = self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: titleContainerStyle.edgeInsets.top)
        let containerTrailing = self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: titleContainerStyle.edgeInsets.right)
        let containerBottom = self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: titleContainerStyle.edgeInsets.bottom)
        NSLayoutConstraint.activate([containerLeading, containerTop, containerTrailing, containerBottom])
    }
    
    private func makeBadgeConstraints(titleContainerStyle: TitleContainerStyle) {
        if titleContainerStyle.badgeStyle == .number {
            let containerLeading = self.badgeContainerLabel.leadingAnchor.constraint(equalTo: self.badgeView.leadingAnchor, constant: 6.0)
            let containerTrailing = self.badgeContainerLabel.trailingAnchor.constraint(equalTo: self.badgeView.trailingAnchor, constant: -6.0)
            let containerCenterX = self.badgeContainerLabel.centerXAnchor.constraint(equalTo: self.badgeView.centerXAnchor)
            let containerCenterY = self.badgeContainerLabel.centerYAnchor.constraint(equalTo: self.badgeView.centerYAnchor)
            NSLayoutConstraint.activate([containerLeading, containerTrailing, containerCenterX, containerCenterY])
        }
        
        let badgeWidth = self.badgeView.widthAnchor.constraint(greaterThanOrEqualToConstant: titleContainerStyle.badgeStyle == .number ? 20.0 : 8.0)
        let badgeHeight = self.badgeView.heightAnchor.constraint(equalToConstant: titleContainerStyle.badgeStyle == .number ? 20.0 : 8.0)
        let badgeCenterX = self.badgeView.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: titleContainerStyle.badgeEdgeInsets.right - titleContainerStyle.badgeEdgeInsets.left)
        let badgeCenterY = self.badgeView.centerYAnchor.constraint(equalTo: self.topAnchor, constant: titleContainerStyle.badgeEdgeInsets.bottom - titleContainerStyle.badgeEdgeInsets.top)
        NSLayoutConstraint.activate([badgeWidth, badgeHeight, badgeCenterX, badgeCenterY])
    }
    
    private func setLayerAttributes() {
        self.badgeView.layer.cornerRadius = self.titleContainerStyle.badgeStyle == .number ? 10.0 : 4.0
        self.badgeView.layer.borderColor = self.titleContainerStyle.badgeBorderColor
        self.badgeView.layer.borderWidth = self.titleContainerStyle.badgeBorderWidth
    }
}

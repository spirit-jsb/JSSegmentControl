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
    
    public var badge: Int = 0 {
        willSet {
            self.badgeView.isHidden = self.style.isBadgeHidden ? true : newValue == 0
            if self.style.badgeStyle == .number, !self.style.isBadgeHidden {
                self.badgeContainerLabel.text = "\(newValue)"
            }
        }
    }
    
    public var highlightedTextColor: UIColor? {
        willSet {
            self.titleView.highlightedTextColor = newValue
        }
    }
    
    let style: TitleContainerStyle
    
    var isSelected: Bool = false {
        willSet {
            self.titleView.isHighlighted = newValue
            self.imageView.isHighlighted = newValue
        }
    }
    
    var isZoomed: Bool = false {
        willSet {
            let scale = newValue ? self.style.maximumZoomScale : 1.0
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = self.style.titleFont
        label.textColor = self.style.titleTextColor
        label.highlightedTextColor = self.style.titleHighlightedTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var badgeView: UIView = {
        let view = UIView()
        view.isHidden = self.style.isBadgeHidden
        view.backgroundColor = self.style.badgeBackgroundColor
        view.layer.cornerRadius = self.style.badgeStyle == .number ? 10.0 : 4.0
        view.layer.masksToBounds = true
        view.layer.borderColor = self.style.badgeBorderColor
        view.layer.borderWidth = self.style.badgeBorderWidth
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var badgeContainerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = self.badgeView.backgroundColor
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textColor = self.style.badgeTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.badgeView.addSubview(label)
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = self.style.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        return stackView
    }()
    
    // MARK:
    public init(style: TitleContainerStyle) {
        self.style = style
        super.init(frame: .zero)
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        let function = #function
        let file = #file.split(separator: "/").last ?? "null"
        let line = #line
        print(file, line, function)
        #endif
    }
    
    // MARK:
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let _ = newSuperview else {
            return
        }
        
        switch self.style.position {
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
        self.addSubview(self.badgeView)
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        self.makeConstraints()
    }
    
    // MARK:
    private func configView() {
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: 私有方法
    private func makeConstraints() {
        switch self.style.position {
        case .center:
            self.makeCenterConstraints()
        default:
            self.makeContainerConstraints()
        }
        self.makeBadgeConstraints()
        self.layoutIfNeeded()
    }
    
    private func makeContainerConstraints() {
        let containerLeading = self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.style.edgeInsets.left)
        let containerTop = self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.style.edgeInsets.top)
        let containerTrailing = self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.style.edgeInsets.right)
        let containerBottom = self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.style.edgeInsets.bottom)
        NSLayoutConstraint.activate([containerLeading, containerTop, containerTrailing, containerBottom])
    }
    
    private func makeCenterConstraints() {
        let imageLeading = self.imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: self.style.edgeInsets.left)
        let imageTop = self.imageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: self.style.edgeInsets.top)
        let imageTrailing = self.imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: self.style.edgeInsets.right)
        let imageBottom = self.imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: self.style.edgeInsets.bottom)
        let imageCenterX = self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let imageCenterY = self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([imageLeading, imageTop, imageTrailing, imageBottom, imageCenterX, imageCenterY])
        
        let titleLeading = self.titleView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: self.style.edgeInsets.left)
        let titleTop = self.titleView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: self.style.edgeInsets.top)
        let titleTrailing = self.titleView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: self.style.edgeInsets.right)
        let titleBottom = self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: self.style.edgeInsets.bottom)
        let titleCenterX = self.titleView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let titleCenterY = self.titleView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([titleLeading, titleTop, titleTrailing, titleBottom, titleCenterX, titleCenterY])
    }
    
    private func makeBadgeConstraints() {
        if self.style.badgeStyle == .number {
            let containerLeading = self.badgeContainerLabel.leadingAnchor.constraint(equalTo: self.badgeView.leadingAnchor, constant: 4.0)
            let containerTrailing = self.badgeContainerLabel.trailingAnchor.constraint(equalTo: self.badgeView.trailingAnchor, constant: -4.0)
            let containerCenterX = self.badgeContainerLabel.centerXAnchor.constraint(equalTo: self.badgeView.centerXAnchor)
            let containerCenterY = self.badgeContainerLabel.centerYAnchor.constraint(equalTo: self.badgeView.centerYAnchor)
            NSLayoutConstraint.activate([containerLeading, containerTrailing, containerCenterX, containerCenterY])
        }
        
        let badgeWidth = self.badgeView.widthAnchor.constraint(greaterThanOrEqualToConstant: self.style.badgeStyle == .number ? 20.0 : 8.0)
        let badgeHeight = self.badgeView.heightAnchor.constraint(equalToConstant: self.style.badgeStyle == .number ? 20.0 : 8.0)
        let badgeCenterX = self.badgeView.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: self.style.badgeEdgeInsets.left + self.style.badgeEdgeInsets.right)
        let badgeCenterY = self.badgeView.centerYAnchor.constraint(equalTo: self.topAnchor, constant: self.style.badgeEdgeInsets.top + self.style.badgeEdgeInsets.bottom)
        NSLayoutConstraint.activate([badgeWidth, badgeHeight, badgeCenterX, badgeCenterY])
    }
}

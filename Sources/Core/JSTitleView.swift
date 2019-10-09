//
//  JSTitleView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSTitleView: UIScrollView {
    
    // MARK:
    private let titleStyle: TitleStyle
    private let titleContainerStyle: TitleContainerStyle
    
    private let containerView: UIStackView = UIStackView()
    private let titleMaskView: UIView = UIView()
    private let titleLineView: UIView = UIView()
    
    weak var titleDataSource: JSTitleDataSource?
    weak var titleDelegate: JSTitleDelegate?
    
    private var presentIndex: Int = 0
    private var pastIndex: Int = 0
    
    // MARK:
    public init(titleStyle: TitleStyle, titleContainerStyle: TitleContainerStyle) {
        self.titleStyle = titleStyle
        self.titleContainerStyle = titleContainerStyle
        
        super.init(frame: .zero)
        
        self.constructView(titleStyle: titleStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugLog()
    }
    
    // MARK:
    func reload() {
        self.pastIndex = 0
        self.presentIndex = 0
        
        self.containerView.arrangedSubviews.forEach {
            self.containerView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        self.subviews.forEach { $0.removeFromSuperview() }
                
        self.constructView(titleStyle: self.titleStyle)
        
        self.setContentOffset(.zero, animated: false)
    }
    
    func dequeueReusableTitle(at index: Int) -> JSTitleContainerView {
        guard let titleContainerView = self.containerView.arrangedSubviews[safe: index] as? JSTitleContainerView else {
            return JSTitleContainerView(titleContainerStyle: self.titleContainerStyle)
        }
        return titleContainerView
    }
    
    func selected(index: Int) {
        guard index >= 0, index < self.containerView.arrangedSubviews.count else {
            return
        }
        self.selectedAnimation(from: self.pastIndex, to: index)
    }
    
    func selectedAnimation(progress: CGFloat, from pastIndex: Int, to presentIndex: Int) {
        guard pastIndex != presentIndex,
            let pastContainer = self.containerView.arrangedSubviews[safe: pastIndex] as? JSTitleContainerView,
            let presentContainer = self.containerView.arrangedSubviews[safe: presentIndex] as? JSTitleContainerView else
        {
            return
        }
        
        let centerXDistance = presentContainer.center.x - pastContainer.center.x
        let widthDistance = presentContainer.bounds.width - pastContainer.bounds.width
        let maximumZoomScale = self.titleContainerStyle.maximumZoomScale
        let scaleDistance = maximumZoomScale - 1.0
        
        if !self.titleStyle.isMaskHidden {
            self.titleMaskView.frame.size.width = self.titleStyle.isAdjustMaskAndLineSize ? pastContainer.bounds.width + widthDistance * progress : self.titleStyle.maskWidth
            self.titleMaskView.center.x = pastContainer.center.x + centerXDistance * progress + self.titleStyle.edgeInsets.left
        }
        if !self.titleStyle.isLineHidden {
            self.titleLineView.bounds.size.width = self.titleStyle.isAdjustMaskAndLineSize ? pastContainer.bounds.width + widthDistance * progress : self.titleStyle.lineWidth
            self.titleLineView.center.x = pastContainer.center.x + centerXDistance * progress + self.titleStyle.edgeInsets.left
        }
        if self.titleStyle.isZoomEnabled {
            pastContainer.transform = CGAffineTransform(scaleX: maximumZoomScale - scaleDistance * progress, y: maximumZoomScale - scaleDistance * progress)
            presentContainer.transform = CGAffineTransform(scaleX: 1.0 + scaleDistance * progress, y: 1.0 + scaleDistance * progress)
        }
    }
    
    // MARK:
    private func constructView(titleStyle: TitleStyle) {
        self.backgroundColor = UIColor.clear
        self.bounces = titleStyle.isBouncesEnabled
        self.alwaysBounceHorizontal = true
        self.isScrollEnabled = titleStyle.isScrollEnabled
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.scrollsToTop = false
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.axis = .horizontal
        self.containerView.distribution = titleStyle.isForceEqualContainerSize ? .fillEqually : .fill
        self.containerView.alignment = .center
        self.containerView.spacing = titleStyle.spacing
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
        
        guard let strongTitleDataSource = self.titleDataSource else {
            return
        }
        
        let numberOfTitles = strongTitleDataSource.numberOfTitles()
        (0..<numberOfTitles).forEach { [weak self] (index) in
            guard let strongSelf = self else { return }
            
            let titleContainerView = strongTitleDataSource.titleView(strongSelf, containerAt: index)
            titleContainerView.tag = index
            titleContainerView.isSelected = index == strongSelf.presentIndex
            titleContainerView.isZoomed = titleStyle.isZoomEnabled ? index == strongSelf.presentIndex : false
            let tapGesture = UITapGestureRecognizer(target: strongSelf, action: #selector(titleContainerViewTrigger(_:)))
            titleContainerView.addGestureRecognizer(tapGesture)
            strongSelf.containerView.addArrangedSubview(titleContainerView)
        }
        
        if !titleStyle.isMaskHidden {
            self.titleMaskView.backgroundColor = titleStyle.maskColor
            self.insertSubview(self.titleMaskView, at: 0)
        }
        
        if !titleStyle.isLineHidden {
            self.titleLineView.backgroundColor = titleStyle.lineColor
            self.addSubview(self.titleLineView)
        }
        
        self.makeContainerViewConstraints(titleStyle: titleStyle)
        self.makeTitleContainerViewConstraints(titleStyle: titleStyle)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        #warning("presentContainer 无法拿到正常大小")
        self.makeMaskAndLineLayout(titleStyle: titleStyle)
        self.setLayerAttributes()
    }
    
    // MARK:
    private func makeContainerViewConstraints(titleStyle: TitleStyle) {
        let containerLeading = self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleStyle.edgeInsets.left)
        let containerTop = self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: titleStyle.edgeInsets.top)
        let containerTrailing = self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: titleStyle.edgeInsets.right)
        let containerBottom = self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: titleStyle.edgeInsets.bottom)
        let containerCenterY = self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([containerLeading, containerTop, containerTrailing, containerBottom, containerCenterY])
        
        if self.titleStyle.isForceEqualContainerSize {
            let containerWidth = self.containerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: (self.titleStyle.edgeInsets.right - self.titleStyle.edgeInsets.left))
            NSLayoutConstraint.activate([containerWidth])
        }
    }
    
    private func makeTitleContainerViewConstraints(titleStyle: TitleStyle) {
        self.containerView.arrangedSubviews.forEach { (subview) in
            if !titleStyle.isAdjustContainerSize {
                debugLog(items: "禁止 AdjustContainerSize 可能会导致显示异常，请正确设置尺寸。")
                
                let subviewWidth = subview.widthAnchor.constraint(equalToConstant: titleStyle.containerWidth)
                let subviewHeight = subview.heightAnchor.constraint(equalToConstant: titleStyle.containerHeight)
                NSLayoutConstraint.activate([subviewWidth, subviewHeight])
            }
        }
    }
    
    private func makeMaskAndLineLayout(titleStyle: TitleStyle) {
        guard let presentContainer = self.containerView.arrangedSubviews[safe: self.presentIndex] else {
            return
        }
        
        if !titleStyle.isMaskHidden {
            self.titleMaskView.frame.size.width = titleStyle.isAdjustMaskAndLineSize ? presentContainer.bounds.width : titleStyle.maskWidth
            self.titleMaskView.frame.size.height = titleStyle.isAdjustMaskAndLineSize ? presentContainer.bounds.height : titleStyle.maskHeight
            self.titleMaskView.center = CGPoint(x: presentContainer.frame.midX + titleStyle.edgeInsets.left, y: presentContainer.frame.midY + titleStyle.edgeInsets.top)
        }
        if !titleStyle.isLineHidden {
            self.titleLineView.frame.size.width = titleStyle.isAdjustMaskAndLineSize ? presentContainer.bounds.width : titleStyle.lineWidth
            self.titleLineView.frame.size.height = titleStyle.isAdjustMaskAndLineSize ? 2.0 : titleStyle.lineHeight
            self.titleLineView.center = CGPoint(x: presentContainer.frame.midX + titleStyle.edgeInsets.left, y: presentContainer.frame.maxY + titleStyle.edgeInsets.top)
        }
    }
    
    // MARK:
    private func setLayerAttributes() {
        let maskHeight = self.titleMaskView.bounds.height
        self.titleMaskView.layer.cornerRadius = maskHeight * 0.5
    }
    
    private func resetTitleViewContentOffset() {
        if self.contentSize.width > self.bounds.width,
            let presentTitleContainerView = self.containerView.arrangedSubviews[safe: self.presentIndex]
        {
            var offset = presentTitleContainerView.center.x - (self.bounds.width - self.titleStyle.edgeInsets.left + self.titleStyle.edgeInsets.right) * 0.5
            let maxOffset = self.contentSize.width - self.bounds.width
            if offset < 0.0 {
                offset = 0.0
            }
            if offset > maxOffset {
                offset = maxOffset
            }
            self.setContentOffset(CGPoint(x: offset, y: 0.0), animated: true)
        }
    }
    
    private func selectedAnimation(from pastIndex: Int, to presentIndex: Int) {
        guard pastIndex != presentIndex,
            let pastContainer = self.containerView.arrangedSubviews[safe: pastIndex] as? JSTitleContainerView,
            let presentContainer = self.containerView.arrangedSubviews[safe: presentIndex] as? JSTitleContainerView else
        {
            return
        }
        
        self.presentIndex = presentIndex
        presentContainer.isSelected = true
        self.titleDelegate?.titleView(self, didSelectAt: presentIndex)
        
        self.pastIndex = presentIndex
        pastContainer.isSelected = false
        self.titleDelegate?.titleView(self, didDeselectAt: pastIndex)
        
        UIView.animate(withDuration: 0.25, animations: {
            if self.titleStyle.isZoomEnabled {
                pastContainer.isZoomed = false
                presentContainer.isZoomed = true
            }
            if !self.titleStyle.isMaskHidden {
                self.titleMaskView.frame.size.width = self.titleStyle.isAdjustMaskAndLineSize ? presentContainer.bounds.width : self.titleStyle.maskWidth
                self.titleMaskView.center.x = presentContainer.center.x + self.titleStyle.edgeInsets.left
            }
            if !self.titleStyle.isLineHidden {
                self.titleLineView.frame.size.width = self.titleStyle.isAdjustMaskAndLineSize ? presentContainer.bounds.width : self.titleStyle.lineWidth
                self.titleLineView.center.x = presentContainer.center.x + self.titleStyle.edgeInsets.left
            }
        }, completion: { (_) in
            self.resetTitleViewContentOffset()
        })
    }
    
    // MARK:
    @objc private func titleContainerViewTrigger(_ tapGesture: UITapGestureRecognizer) {
        guard let titleContainer = tapGesture.view as? JSTitleContainerView else {
            return
        }
        self.selectedAnimation(from: self.pastIndex, to: titleContainer.tag)
    }
}

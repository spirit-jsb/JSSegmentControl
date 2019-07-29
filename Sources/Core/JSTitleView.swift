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
    private let style: TitleStyle
    
    weak var titleDataSource: JSTitleDataSource?
    weak var titleDelegate: JSTitleDelegate?
    
    private var pastIndex: Int = 0
    private var presentIndex: Int = 0
    
    private lazy var titleMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.maskColor
        return view
    }()
    
    private lazy var titleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.lineColor
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = self.style.isScrollEnabled ? .fill : .fillEqually
        stackView.alignment = .center
        stackView.spacing = self.style.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK:
    public init(style: TitleStyle) {
        self.style = style
        super.init(frame: .zero)
        self.configView()
        self.configSubview()
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
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.makeMaskAndLineLayout()
        self.setContentSize()
        self.setMaskRoundCorners()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        self.makeConstraints()
    }
    
    // MARK:
    #warning("刷新后line位置存在异常")
    func reload() {
        self.pastIndex = 0
        self.presentIndex = 0
        
        self.containerView.arrangedSubviews.forEach {
            self.containerView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        self.subviews.forEach { $0.removeFromSuperview() }
                
        self.configSubview()
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        
        self.setContentOffset(.zero, animated: false)
    }
    
    func dequeueReusableTitle(at index: Int) -> JSTitleContainerView? {
        return self.containerView.arrangedSubviews[safe: index] as? JSTitleContainerView
    }
    
    func selected(index: Int) {
        self.selectedAnimation(from: self.pastIndex, to: index)
    }
    
    func selectedAnimation(progress: CGFloat, from pastIndex: Int, to presentIndex: Int) {
        guard pastIndex != presentIndex, let pastContainer = self.containerView.arrangedSubviews[safe: pastIndex] as? JSTitleContainerView, let presentContainer = self.containerView.arrangedSubviews[safe: presentIndex] as? JSTitleContainerView else {
            return
        }
        
        let centerXDistance = presentContainer.center.x - pastContainer.center.x
        let widthDistance = presentContainer.bounds.width - pastContainer.bounds.width
        let maximumZoomScale = presentContainer.style.maximumZoomScale
        let scaleDistance = maximumZoomScale - 1.0
        
        if !self.style.isMaskHidden {
            self.titleMaskView.frame.size.width = self.style.isAdjustMaskAndLineSize ? pastContainer.bounds.width + widthDistance * progress : self.style.maskWidth
            self.titleMaskView.center.x = pastContainer.center.x + centerXDistance * progress + self.style.edgeInsets.left
            self.setMaskRoundCorners()
        }
        if !self.style.isLineHidden {
            self.titleLineView.bounds.size.width = self.style.isAdjustMaskAndLineSize ? pastContainer.bounds.width + widthDistance * progress : self.style.lineWidth
            self.titleLineView.center.x = pastContainer.center.x + centerXDistance * progress + self.style.edgeInsets.left
        }
        if self.style.isZoomEnabled {
            pastContainer.transform = CGAffineTransform(scaleX: maximumZoomScale - scaleDistance * progress, y: maximumZoomScale - scaleDistance * progress)
            presentContainer.transform = CGAffineTransform(scaleX: 1.0 + scaleDistance * progress, y: 1.0 + scaleDistance * progress)
        }
    }
    
    // MARK:
    private func configView() {
        self.backgroundColor = UIColor.clear
        self.bounces = self.style.isBouncesEnabled
        self.alwaysBounceHorizontal = true
        self.isScrollEnabled = self.style.isScrollEnabled
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configSubview() {
        self.addSubview(self.containerView)
        
        guard let titleDataSource = self.titleDataSource else {
            return
        }
        
        (0..<titleDataSource.numberOfTitles()).forEach { [unowned self] (index) in
            let titleContainerView = titleDataSource.title(self, containerAt: index)
            titleContainerView.tag = index
            titleContainerView.isSelected = index == self.presentIndex
            titleContainerView.isZoomed = self.style.isZoomEnabled ? index == self.presentIndex : false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewTrigger(_:)))
            titleContainerView.addGestureRecognizer(tapGesture)
            self.containerView.addArrangedSubview(titleContainerView)
        }
        
        if !self.style.isMaskHidden {
            self.insertSubview(self.titleMaskView, at: 0)
        }
        if !self.style.isLineHidden {
            self.addSubview(self.titleLineView)
        }
    }
    
    // MARK:
    private func makeConstraints() {
        self.makeContainerConstraints()
        self.makeTitleContainerConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func makeContainerConstraints() {
        let containerLeading = self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.style.edgeInsets.left)
        let containerTop = self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.style.edgeInsets.top)
        let containerTrailing = self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.style.edgeInsets.right)
        let containerBottom = self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.style.edgeInsets.bottom)
        let containerCenterY = self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([containerLeading, containerTop, containerTrailing, containerBottom, containerCenterY])
        if !self.style.isScrollEnabled {
            let containerWidth = self.containerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(self.style.edgeInsets.left - self.style.edgeInsets.right))
            NSLayoutConstraint.activate([containerWidth])
        }
    }
    
    private func makeTitleContainerConstraints() {
        self.containerView.arrangedSubviews.forEach { [unowned self] (subview) in
            if !self.style.isAdjustContainerSize && self.style.isScrollEnabled {
                #if DEBUG
                print("禁止 AdjustContainerSize 可能会导致显示异常，请正确设置尺寸。")
                #endif
                let subviewWidth = subview.widthAnchor.constraint(equalToConstant: self.style.containerWidth)
                let subviewHeight = subview.heightAnchor.constraint(equalToConstant: self.style.containerHeight)
                NSLayoutConstraint.activate([subviewWidth, subviewHeight])
            }
            else {
                let subviewTop = subview.topAnchor.constraint(equalTo: self.containerView.topAnchor)
                let subviewBottom = subview.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
                NSLayoutConstraint.activate([subviewTop, subviewBottom])
            }
        }
    }
    
    private func makeMaskAndLineLayout() {
        guard let presentContainer = self.containerView.arrangedSubviews[safe: self.presentIndex] else {
            return
        }
        if !self.style.isMaskHidden {
            self.titleMaskView.frame.size.width = self.style.isAdjustMaskAndLineSize ? presentContainer.bounds.width : self.style.maskWidth
            self.titleMaskView.frame.size.height = self.style.isAdjustMaskAndLineSize ? presentContainer.bounds.height : self.style.maskHeight
            self.titleMaskView.center = CGPoint(x: presentContainer.frame.midX + self.style.edgeInsets.left, y: presentContainer.frame.midY + self.style.edgeInsets.top)
        }
        if !self.style.isLineHidden {
            self.titleLineView.frame.size.width = self.style.isAdjustMaskAndLineSize ? presentContainer.bounds.width : self.style.lineWidth
            self.titleLineView.frame.size.height = self.style.isAdjustMaskAndLineSize ? 2.0 : self.style.lineHeight
            self.titleLineView.center = CGPoint(x: presentContainer.frame.midX + self.style.edgeInsets.left, y: presentContainer.frame.maxY + self.style.edgeInsets.top)
        }
    }
    
    // MARK:
    private func setContentSize() {
        self.contentSize.height = 0.0
    }
    
    private func setMaskRoundCorners() {
        let maskHeight = self.titleMaskView.bounds.height
        self.titleMaskView.roundCorners(.allCorners, radius: maskHeight / 2.0)
    }
    
    private func resetTitleViewOffset() {
        if self.contentSize.width > self.bounds.width {
            var offset = self.containerView.arrangedSubviews[self.presentIndex].center.x - self.bounds.width * 0.5
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
        guard pastIndex != presentIndex, let pastContainer = self.containerView.arrangedSubviews[safe: pastIndex] as? JSTitleContainerView, let presentContainer = self.containerView.arrangedSubviews[safe: presentIndex] as? JSTitleContainerView else {
            return
        }
        
        self.presentIndex = presentIndex
        presentContainer.isSelected = true
        self.titleDelegate?.title(self, didSelectAt: presentIndex)
        
        self.pastIndex = presentIndex
        pastContainer.isSelected = false
        self.titleDelegate?.title(self, didDeselectAt: pastIndex)
        
        UIView.animate(withDuration: 0.25, animations: {
            if self.style.isZoomEnabled {
                pastContainer.isZoomed = false
                presentContainer.isZoomed = true
            }
            if !self.style.isMaskHidden {
                self.titleMaskView.frame.size.width = self.style.isAdjustMaskAndLineSize ? presentContainer.bounds.width : self.style.maskWidth
                self.titleMaskView.center.x = presentContainer.center.x + self.style.edgeInsets.left
                self.setMaskRoundCorners()
            }
            if !self.style.isLineHidden {
                self.titleLineView.frame.size.width = self.style.isAdjustMaskAndLineSize ? presentContainer.bounds.width : self.style.lineWidth
                self.titleLineView.center.x = presentContainer.center.x + self.style.edgeInsets.left
            }
        }, completion: { (_) in
            self.resetTitleViewOffset()
        })
    }
    
    // MARK:
    @objc private func containerViewTrigger(_ tapGesture: UITapGestureRecognizer) {
        guard let titleContainer = tapGesture.view as? JSTitleContainerView else {
            return
        }
        self.selectedAnimation(from: self.pastIndex, to: titleContainer.tag)
    }
}

//
//  JSSegmentControlProtocol.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

@objc protocol JSTitleDataSource: NSObjectProtocol {
    @objc func numberOfTitles() -> Int
    @objc func title(_ title: JSTitleView, containerAt index: Int) -> JSTitleContainerView
}

@objc protocol JSTitleDelegate: NSObjectProtocol {
    @objc func title(_ title: JSTitleView, didSelectAt index: Int)
    @objc func title(_ title: JSTitleView, didDeselectAt index: Int)
}

@objc protocol JSContentDataSource: NSObjectProtocol {
    @objc func numberOfContents() -> Int
    @objc func content(_ content: JSContentView, containerAt index: Int) -> UIViewController
}

@objc protocol JSContentDelegate: NSObjectProtocol {
    @objc func content(selected index: Int)
    @objc func content(selectedAnimation progress: CGFloat, from pastIndex: Int, to presentIndex: Int)
    @objc optional func content(_ content: JSContentView, willAppear controller: UIViewController, forItemAt index: Int)
    @objc optional func content(_ content: JSContentView, didAppear controller: UIViewController, forItemAt index: Int)
    @objc optional func content(_ content: JSContentView, willDisappear controller: UIViewController, forItemAt index: Int)
    @objc optional func content(_ content: JSContentView, didDisappear controller: UIViewController, forItemAt index: Int)
}

@objc public protocol JSSegmentControlDataSource: NSObjectProtocol {
    @objc func numberOfSegments() -> Int
    @objc func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView
    @objc func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController
}

@objc public protocol JSSegmentControlDelegate: NSObjectProtocol {
    @objc optional func segmentControl(_ segmentControl: JSSegmentControl, didSelectAt index: Int)
    @objc optional func segmentControl(_ segmentControl: JSSegmentControl, didDeselectAt index: Int)
    @objc optional func segmentControl(_ segmentControl: JSSegmentControl, willAppear controller: UIViewController, forItemAt index: Int)
    @objc optional func segmentControl(_ segmentControl: JSSegmentControl, didAppear controller: UIViewController, forItemAt index: Int)
    @objc optional func segmentControl(_ segmentControl: JSSegmentControl, willDisappear controller: UIViewController, forItemAt index: Int)
    @objc optional func segmentControl(_ segmentControl: JSSegmentControl, didDisappear controller: UIViewController, forItemAt index: Int)
}

//
//  JSSegmentControlProtocol.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

protocol JSTitleDataSource: NSObjectProtocol {
    func numberOfTitles() -> Int
    func titleView(_ titleView: JSTitleView, containerAt index: Int) -> JSTitleContainerView
}

protocol JSTitleDelegate: NSObjectProtocol {
    func titleView(_ titleView: JSTitleView, didSelectAt index: Int)
    func titleView(_ titleView: JSTitleView, didDeselectAt index: Int)
}

protocol JSContentDataSource: NSObjectProtocol {
    func numberOfContents() -> Int
    func contentView(_ contentView: JSContentView, containerAt index: Int) -> UIViewController
}

protocol JSContentDelegate: NSObjectProtocol {
    func contentView(selected index: Int)
    func contentView(selectedAnimation progress: CGFloat, from pastIndex: Int, to presentIndex: Int)
    func contentView(_ contentView: JSContentView, willAppear controller: UIViewController, forItemAt index: Int)
    func contentView(_ contentView: JSContentView, didAppear controller: UIViewController, forItemAt index: Int)
    func contentView(_ contentView: JSContentView, willDisappear controller: UIViewController, forItemAt index: Int)
    func contentView(_ contentView: JSContentView, didDisappear controller: UIViewController, forItemAt index: Int)
}

extension JSContentDelegate {
    func contentView(_ contentView: JSContentView, willAppear controller: UIViewController, forItemAt index: Int) {  }
    func contentView(_ contentView: JSContentView, didAppear controller: UIViewController, forItemAt index: Int) {  }
    func contentView(_ contentView: JSContentView, willDisappear controller: UIViewController, forItemAt index: Int) {  }
    func contentView(_ contentView: JSContentView, didDisappear controller: UIViewController, forItemAt index: Int) {  }
}

public protocol JSSegmentControlDataSource: NSObjectProtocol {
    func numberOfSegments() -> Int
    func segmentControl(_ segmentControl: JSSegmentControl, titleAt index: Int) -> JSTitleContainerView
    func segmentControl(_ segmentControl: JSSegmentControl, contentAt index: Int) -> UIViewController
}

public protocol JSSegmentControlDelegate: NSObjectProtocol {
    func segmentControl(_ segmentControl: JSSegmentControl, didSelectAt index: Int)
    func segmentControl(_ segmentControl: JSSegmentControl, didDeselectAt index: Int)
    func segmentControl(_ segmentControl: JSSegmentControl, willAppear controller: UIViewController, forItemAt index: Int)
    func segmentControl(_ segmentControl: JSSegmentControl, didAppear controller: UIViewController, forItemAt index: Int)
    func segmentControl(_ segmentControl: JSSegmentControl, willDisappear controller: UIViewController, forItemAt index: Int)
    func segmentControl(_ segmentControl: JSSegmentControl, didDisappear controller: UIViewController, forItemAt index: Int)
}

extension JSSegmentControlDelegate {
    func segmentControl(_ segmentControl: JSSegmentControl, didSelectAt index: Int) {  }
    func segmentControl(_ segmentControl: JSSegmentControl, didDeselectAt index: Int) {  }
    func segmentControl(_ segmentControl: JSSegmentControl, willAppear controller: UIViewController, forItemAt index: Int) {  }
    func segmentControl(_ segmentControl: JSSegmentControl, didAppear controller: UIViewController, forItemAt index: Int) {  }
    func segmentControl(_ segmentControl: JSSegmentControl, willDisappear controller: UIViewController, forItemAt index: Int) {  }
    func segmentControl(_ segmentControl: JSSegmentControl, didDisappear controller: UIViewController, forItemAt index: Int) {  }
}

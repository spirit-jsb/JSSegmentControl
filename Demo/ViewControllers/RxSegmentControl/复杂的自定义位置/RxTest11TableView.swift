//
//  RxTest11TableView.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/24.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class RxTest11TableView: UITableView, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}

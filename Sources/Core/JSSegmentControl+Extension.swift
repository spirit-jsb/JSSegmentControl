//
//  JSSegmentControl+Extension.swift
//  JSSegmentControl
//
//  Created by Max on 2019/7/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

extension Array {
    
    // MARK:
    subscript(safe index: Int) -> Element? {
        set {
            let safeIndex = self.indices ~= index ? index : (self.indices.endIndex - 1)
            if let safeValue = newValue {
                self[safeIndex] = safeValue
            }
        }
        get {
            return self.indices ~= index ? self[index] : nil
        }
    }
}

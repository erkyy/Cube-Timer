//
//  Extensions.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-23.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle() {
        for i in (0..<self.count).reversed() {
            let i1 = i
            let i2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[i1], self[i2]) = (self[i2], self[i1])
        }
    }
}

extension UIColor {
    public static func randomized() -> UIColor {
        let random = (CGFloat(arc4random_uniform(32)) + 48) / 100
        
        return UIColor(hue: random, saturation: 1, brightness: 0.4, alpha: 1)
    }
}


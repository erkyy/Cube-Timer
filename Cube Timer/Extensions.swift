//
//  Extensions.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-23.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let i1 = i
            let i2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[i1], self[i2]) = (self[i2], self[i1])
        }
    }
}

extension UIColor {
    public static func randomized() -> UIColor {
        var randomArray = [CGFloat]()
        let random1 = CGFloat(arc4random_uniform(15)) / 100
        //0.55 to 0.75
        let random2 = (CGFloat(arc4random_uniform(35)) + 40) / 100
        
        randomArray.append(random1)
        randomArray.append(random2)
        
        let i = Int(arc4random_uniform(2))
        
        return UIColor(hue: randomArray[i], saturation: 1, brightness: 1, alpha: 1)
    }
}

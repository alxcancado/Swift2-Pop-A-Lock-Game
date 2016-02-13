//
//  Extensions.swift
//  Pop A Lock
//
//  Created by Alex Lima Lopes Cancado on 13/02/16.
//  Copyright © 2016 Alex Lima Lopes Cancado. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}
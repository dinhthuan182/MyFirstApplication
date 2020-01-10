//
//  UIColor+Extensions.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/8/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func customRGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}

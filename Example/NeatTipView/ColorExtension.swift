//
//  ColorExtension.swift
//  NeatTipView_Example
//
//  Created by Germán Stábile on 9/27/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
  
  static let greeny = UIColor(red: 38, green: 208, blue: 124)
  static let purply = UIColor(red: 77, green: 73, blue: 190)
  static let altoGray = UIColor(red: 216, green: 216, blue: 216)
  static let cadetBlue = UIColor(red: 167, green: 175, blue: 199)
  
  convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: min(CGFloat(red), 255.0) / 255.0,
              green: min(CGFloat(green), 255.0) / 255.0,
              blue: min(CGFloat(blue), 255.0) / 255.0,
              alpha: 1.0)
  }
}

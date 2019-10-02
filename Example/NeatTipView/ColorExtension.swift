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
  static let paleRose = UIColor(red: 255, green: 225, blue: 242)
  static let gold = UIColor(red: 255, green: 215, blue: 0)
  
  static let aquamarineGreen = UIColor(red: 112, green: 255, blue: 176)
  static let heliotropePurple = UIColor(red: 212, green: 115, blue: 255)
  static let anakiwaBlue = UIColor(red: 112, green: 237, blue: 255)
  static let sharkBlack = UIColor(red: 38, green: 40, blue: 43)
  
  convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: min(CGFloat(red), 255.0) / 255.0,
              green: min(CGFloat(green), 255.0) / 255.0,
              blue: min(CGFloat(blue), 255.0) / 255.0,
              alpha: 1.0)
  }
}

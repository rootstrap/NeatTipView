//
//  ViewExtension.swift
//  NeatTipView_Example
//
//  Created by sol manini on 10/2/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {
  func addShadow(
    color: UIColor = .gray,
    offset: CGSize = CGSize(width: 1, height: 1),
    opacity: Float = 0.3,
    radius: CGFloat = 5
  ) {
    layer.shadowRadius = radius
    layer.shadowColor = color.cgColor
    layer.shadowOffset = offset
    layer.shadowOpacity = opacity
    layer.masksToBounds = false
  }
}

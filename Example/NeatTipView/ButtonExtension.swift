//
//  ButtonExtension.swift
//  NeatTipView_Example
//
//  Created by sol manini on 10/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIButton {
  func configure(
    bkgColor: UIColor = .aquamarineGreen,
    borderColor: UIColor = .aquamarineGreen,
    cornerRadius: CGFloat = 5,
    borderWidth: CGFloat = 1,
    horizontalPadding: CGFloat = 15,
    verticalPadding: CGFloat = 10,
    titleColor: UIColor = .white
  ) {
    backgroundColor = bkgColor
    layer.cornerRadius = cornerRadius
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = borderWidth
    contentEdgeInsets = UIEdgeInsets(
      top: verticalPadding,
      left: horizontalPadding,
      bottom: verticalPadding,
      right: horizontalPadding
    )
    setTitleColor(titleColor, for: .normal)
  }
}

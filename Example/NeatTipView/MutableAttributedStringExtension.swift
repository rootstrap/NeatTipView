//
//  MutableAttributedStringExtension.swift
//  NeatTipView_Example
//
//  Created by Germán Stábile on 7/19/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
  
  func highlight(text: String, with attributes: [NSAttributedString.Key: Any]) {
    let range = (string as NSString).range(of: text)
    setAttributes(attributes,
                  range: range)
  }
}

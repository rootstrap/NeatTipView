//
//  NeatArrowView.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class NeatArrowView: UIView {
  
  var fillColor: UIColor = .white {
    didSet {
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  var strokeColor: UIColor = .white {
    didSet {
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    configureViews()
  }
  
  func configureViews() {
    backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    fillColor.setFill()
    strokeColor.setStroke()
    
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: bounds.width, y: 0))
    path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
    path.close()
    path.stroke()
    path.fill()
  }
}

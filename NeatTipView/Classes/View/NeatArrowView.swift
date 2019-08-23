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
  
  var arrowPosition: ArrowPosition = .bottom {
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
  
  public convenience init(with arrowPosition: ArrowPosition) {
    self.init(frame: .zero)
    
    self.arrowPosition = arrowPosition
  }
  
  func configureViews() {
    backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    fillColor.setFill()
    strokeColor.setStroke()
    
    let path = UIBezierPath()
    
    drawingPoints.enumerated().forEach { index, point in
      if index == 0 {
        path.move(to: point)
      } else {
        path.addLine(to: point)
      }
    }
    path.close()
    path.stroke()
    path.fill()
  }
  
  var drawingPoints: [CGPoint] {
    switch arrowPosition {
    case .top:
      return topDrawingPoints
    case .left:
      return leftDrawingPoints
    case .bottom, .any:
      return bottomDrawingPoints
    case .right:
      return rightDrawingPoints
    }
  }
    
  var topDrawingPoints: [CGPoint] {
    return [CGPoint(x: 0, y: bounds.height),
            CGPoint(x: bounds.width / 2, y: 0),
            CGPoint(x: bounds.width, y: bounds.height)]
  }
  
  var bottomDrawingPoints: [CGPoint] {
    return [CGPoint(x: 0, y: 0),
            CGPoint(x: bounds.width, y: 0),
            CGPoint(x: bounds.width / 2, y: bounds.height)]
  }
  
  var leftDrawingPoints: [CGPoint] {
    return [CGPoint(x: 0, y: bounds.height / 2),
            CGPoint(x: bounds.width, y: 0),
            CGPoint(x: bounds.width, y: bounds.height)]
  }
  
  var rightDrawingPoints: [CGPoint] {
    return [CGPoint(x: 0, y: 0),
            CGPoint(x: bounds.width, y: bounds.height / 2),
            CGPoint(x: 0, y: bounds.height)]
  }
}

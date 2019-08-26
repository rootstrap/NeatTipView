//
//  NeatArrowView.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

struct NeatArrowPath {
  let minBounds: CGFloat = 8

  let position: ArrowPosition

  let center: CGPoint

  let width: CGFloat

  let height: CGFloat

  let frame: CGRect

  var path: UIBezierPath {
    let path = UIBezierPath()

    drawingPoints.enumerated().forEach { index, point in
      if index == 0 {
        path.move(to: point)
      } else {
        path.addLine(to: point)
      }
    }
    path.close()

    return path
  }

  var drawingPoints: [CGPoint] {
    switch position {
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
    let initialX = max(center.x - frame.origin.x - (width / 2), minBounds)
    let midX = center.x - frame.origin.x
    let finalX = midX + (width / 2)
    return [CGPoint(x: initialX, y: height),
            CGPoint(x: midX, y: 0),
            CGPoint(x: finalX, y: height)]
  }

  var bottomDrawingPoints: [CGPoint] {
    let initialX = max(center.x - frame.origin.x - (width / 2), minBounds)
    let midX = initialX + (width / 2)
    let finalX = initialX + width
    let endY = frame.height - height
    return [CGPoint(x: initialX, y: endY),
            CGPoint(x: midX, y: frame.height),
            CGPoint(x: finalX, y: endY)]
  }

  var leftDrawingPoints: [CGPoint] {
    let initialY = max(center.y - (width / 2) - frame.origin.y, minBounds)
    let midY = initialY + (width / 2)
    let finalY = initialY + width
    return [CGPoint(x: height, y: initialY),
            CGPoint(x: 0, y: midY),
            CGPoint(x: height, y: finalY)]
  }

  var rightDrawingPoints: [CGPoint] {
    let initialY = max(center.y - (width / 2) - frame.origin.y, minBounds)
    let midY = initialY + (width / 2)
    let finalY = initialY + width
    let endX = frame.width - height
    return [CGPoint(x: endX, y: initialY),
            CGPoint(x: frame.width, y: midY),
            CGPoint(x: endX, y: finalY)]
  }
}

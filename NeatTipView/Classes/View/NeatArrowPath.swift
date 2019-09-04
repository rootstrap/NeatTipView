//
//  NeatArrowView.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

/**
 NeatArrowPath helper used to store and calculate the actual arrow path.
*/
struct NeatArrowPath {
  /// Minimum distance to the edge of the frame so the arrow does not clip the view.
  let minBounds: CGFloat = 8

  /// The arrow position.
  let position: ArrowPosition

  /// The center point used to start drawing.
  let center: CGPoint

  /// The width of the arrow.
  let width: CGFloat

  /// The height of the arrow
  let height: CGFloat

  /// The containing frame where the arrow will be drawn.
  let frame: CGRect

  /// The offset created by stroking a border (needed to offset the path so it merges with the bubble)
  let borderOffset: CGFloat

  /**
   Returns an instance of UIBezierPath that has the shape and position of the arrow.
  */
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

  /// Returns the drawing point for a specific position
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
    let initialY = height + borderOffset
    return [CGPoint(x: initialX, y: initialY),
            CGPoint(x: midX, y: 0),
            CGPoint(x: finalX, y: initialY)]
  }

  var bottomDrawingPoints: [CGPoint] {
    let initialX = max(center.x - frame.origin.x - (width / 2), minBounds)
    let midX = initialX + (width / 2)
    let finalX = initialX + width
    let endY = frame.height - height - borderOffset
    return [CGPoint(x: initialX, y: endY),
            CGPoint(x: midX, y: frame.height),
            CGPoint(x: finalX, y: endY)]
  }

  var leftDrawingPoints: [CGPoint] {
    let initialY = max(center.y - (width / 2) - frame.origin.y, minBounds)
    let midY = initialY + (width / 2)
    let finalY = initialY + width
    let initialX = height + borderOffset
    return [CGPoint(x: initialX, y: initialY),
            CGPoint(x: 0, y: midY),
            CGPoint(x: initialX, y: finalY)]
  }

  var rightDrawingPoints: [CGPoint] {
    let initialY = max(center.y - (width / 2) - frame.origin.y, minBounds)
    let midY = initialY + (width / 2)
    let finalY = initialY + width
    let endX = frame.width - height - borderOffset
    return [CGPoint(x: endX, y: initialY),
            CGPoint(x: frame.width, y: midY),
            CGPoint(x: endX, y: finalY)]
  }
}

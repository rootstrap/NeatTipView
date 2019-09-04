//
//  ArrowPosition.swift
//  NeatTipView
//
//  Created by Mauricio Cousillas on 8/23/19.
//

import Foundation

/**
 ArrowPosition defines the available orientations of the view's tip.
 Each case defines where the tip is "pointing" to (so `top` will point upwards for example)
*/
public enum ArrowPosition {
  case top
  case bottom
  case left
  case right
  case any

  // MARK: Helpers
  var isVerticalArrow: Bool {
    return self == .top || self == .bottom
  }
  /// Returns the position counter part
  var counterpart: ArrowPosition {
    switch self {
    case .left:
      return .right
    case .right:
      return .left
    case .top:
      return .bottom
    case .bottom:
      return .top
    default:
      return .any
    }
  }

  /// Returns the available positions for the vertical axis
  static var verticalPositions: [ArrowPosition] {
    return [.top, .bottom]
  }

  /// Returns the available positions for the horizontal axis
  static var horizontalPositions: [ArrowPosition] {
    return [.left, .right]
  }
}

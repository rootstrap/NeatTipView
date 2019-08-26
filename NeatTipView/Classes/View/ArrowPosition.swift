//
//  File.swift
//  NeatTipView
//
//  Created by Mauricio Cousillas on 8/23/19.
//

import Foundation

public enum ArrowPosition {
  case top
  case bottom
  case left
  case right
  case any

  var isVerticalArrow: Bool {
    return self == .top || self == .bottom
  }

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

  static var verticalPositions: [ArrowPosition] {
    return [.top, .bottom]
  }

  static var horizontalPositions: [ArrowPosition] {
    return [.left, .right]
  }
}

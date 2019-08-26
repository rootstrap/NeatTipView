//
//  NeatTipViewTipHelpers.swift
//  NeatTipView
//
//  Created by Mauricio Cousillas on 8/23/19.
//

import Foundation

extension NeatTipView {

  func tipFits(in superview: UIView, for arrowPosition: ArrowPosition) -> Bool {
    let availableWidth = superview.bounds.width -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2
    let availableHeight = superview.bounds.height -
      superview.safeAreaInsets.bottom - superview.safeAreaInsets.top -
      (layoutPreferences.verticalInsets + layoutPreferences.contentVerticalInsets) * 2

    switch arrowPosition {
    case .bottom:
      return fitsAtTop(in: superview, with: availableWidth)
    case .top:
      return fitsAtBottom(in: superview, with: availableWidth)
    case .left:
      return fitsInRight(in: superview, with: availableHeight)
    case .right:
      return fitsInLeft(in: superview, with: availableHeight)
    default:
      return false
    }
  }

  func fitsAtBottom(in superview: UIView, with availableWidth: CGFloat) -> Bool {
    let availableHeight = superview.bounds.height - superview.safeAreaInsets.bottom - bubbleView.centerPoint.y -
      (layoutPreferences.verticalInsets + layoutPreferences.contentVerticalInsets) * 2 -
      layoutPreferences.arrowHeight

    let size = bubbleView.attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))

    return availableHeight > size.height
  }

  func fitsAtTop(in superview: UIView, with availableWidth: CGFloat) -> Bool {
    let availableHeight = bubbleView.centerPoint.y - superview.safeAreaInsets.top -
      (layoutPreferences.verticalInsets + layoutPreferences.contentVerticalInsets) * 2 -
      layoutPreferences.arrowHeight

    let size = bubbleView.attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))

    return availableHeight > size.height
  }

  func fitsInRight(in superview: UIView, with availableHeight: CGFloat) -> Bool {
    let availableWidth = superview.bounds.width - bubbleView.centerPoint.x -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2 -
      layoutPreferences.arrowHeight

    guard availableWidth > layoutPreferences.minWidth else { return false }

    let size = bubbleView.attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))

    return availableHeight > size.height
  }

  func fitsInLeft(in superview: UIView, with availableHeight: CGFloat) -> Bool {
    let availableWidth = bubbleView.centerPoint.x -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2 -
      layoutPreferences.arrowHeight

    guard availableWidth > layoutPreferences.minWidth else { return false }

    let size = bubbleView.attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))

    return availableHeight > size.height
  }

  func whereDoesItFit(in superview: UIView,
                              preferredPosition: ArrowPosition) -> ArrowPosition? {
    if tipFits(in: superview, for: preferredPosition) {
      return preferredPosition
    } else if tipFits(in: superview, for: preferredPosition.counterpart) {
      return preferredPosition.counterpart
    }

    let remainingPositions = preferredPosition.isVerticalArrow ?
      ArrowPosition.horizontalPositions :
      ArrowPosition.verticalPositions

    return remainingPositions.first { tipFits(in: superview, for: $0) }
  }
}

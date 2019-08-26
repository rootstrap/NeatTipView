//
//  NeatTipViewConstraintsInitialization.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/22/19.
//

import UIKit

extension NeatTipView {
  
  //MARK: Bubble constraints
  
  func createBubbleConstraints() -> [NSLayoutConstraint] {
    return arrowPosition.isVerticalArrow ?
      createVerticalBubbleConstraints() :
      createHorizontalBubbleConstraints()
  }
  
  func createVerticalBubbleConstraints() -> [NSLayoutConstraint] {
    return [
      bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor,
                                          constant: layoutPreferences.horizontalInsets),
      bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                           constant: -layoutPreferences.horizontalInsets),
    ]
  }
  
  func createHorizontalBubbleConstraints() -> [NSLayoutConstraint] {
    return [
      bubbleView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
                                         constant: -layoutPreferences.verticalInsets),
      bubbleToViewHorizontalConstraint()
    ]
  }
  
  func bubbleToViewHorizontalConstraint() -> NSLayoutConstraint {
    if arrowPosition == .left {
      return bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -layoutPreferences.horizontalInsets)
    } else {
      return bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: layoutPreferences.horizontalInsets)
    }
  }
}

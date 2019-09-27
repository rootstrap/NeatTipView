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
    return arrowPosition.isVerticalArrow ? verticalBubbleConstraints : horizontalBubbleConstraints
  }
  
  var verticalBubbleConstraints: [NSLayoutConstraint] {
    return [
      bubbleView.leadingAnchor.constraint(
        greaterThanOrEqualTo: leadingAnchor,
        constant: layoutPreferences.horizontalInsets
      ),
      bubbleView.trailingAnchor.constraint(
        lessThanOrEqualTo: trailingAnchor,
        constant: -layoutPreferences.horizontalInsets
      ),
    ]
  }
  
  var horizontalBubbleConstraints: [NSLayoutConstraint] {
    return [
      bubbleView.bottomAnchor.constraint(
        lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
        constant: -layoutPreferences.verticalInsets
      ),
      bubbleToViewHorizontalConstraint
    ]
  }
  
  var bubbleToViewHorizontalConstraint: NSLayoutConstraint {
    if arrowPosition == .left {
      return bubbleView.trailingAnchor.constraint(
        lessThanOrEqualTo: trailingAnchor,
        constant: -layoutPreferences.horizontalInsets
      )
    } else {
      return bubbleView.leadingAnchor.constraint(
        greaterThanOrEqualTo: leadingAnchor,
        constant: layoutPreferences.horizontalInsets
      )
    }
  }

  var bubblePositionConstraints: [NSLayoutConstraint] {
    let size = bubbleView.attributedString.size()
    let bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: bubbleView.centerPoint.x + layoutPreferences.contentHorizontalInsets - size.width / 2
      )
    bubbleLeadingConstraint.priority = .defaultLow

    switch arrowPosition {
    case .any, .top:
      return [
        bubbleView.topAnchor.constraint(
          equalTo: topAnchor,
          constant: bubbleView.centerPoint.y + layoutPreferences.contentVerticalInsets
        ),
        bubbleLeadingConstraint,
        bubbleView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
      ]
    case .bottom:
      return [
        bubbleView.bottomAnchor.constraint(
          equalTo: topAnchor,
          constant: bubbleView.centerPoint.y - layoutPreferences.contentVerticalInsets
        ),
        bubbleLeadingConstraint
      ]
    case .left:
      return [
        bubbleView.leadingAnchor.constraint(
          equalTo: leadingAnchor,
          constant: bubbleView.centerPoint.x + layoutPreferences.contentHorizontalInsets
        ),
        verticalCenterBubbleConstraint
      ]
    case .right:
      return [
        bubbleView.trailingAnchor.constraint(
          equalTo: leadingAnchor,
          constant: bubbleView.centerPoint.x - layoutPreferences.contentHorizontalInsets
        ),
        verticalCenterBubbleConstraint
      ]
    }
  }
}

//
//  NeatTipViewConstraintsInitialization.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/22/19.
//

import UIKit

extension NeatTipView {
  
  //MARK: Bubble constraints
  
  func createInitialBubbleConstraints() -> [NSLayoutConstraint] {
    switch animationPreferences.appearanceAnimationType {
    case .fromBottom:
      return [
        bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: layoutPreferences.horizontalInsets),
        bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -layoutPreferences.horizontalInsets),
        bubbleView.topAnchor.constraint(equalTo: bottomAnchor)
      ]
    case .fromTop:
      return [
        bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: layoutPreferences.horizontalInsets),
        bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -layoutPreferences.horizontalInsets),
        bubbleView.bottomAnchor.constraint(equalTo: topAnchor)
      ]
    case .fromLeft:
      return [
        bubbleVerticalConstraint,
        bubbleView.trailingAnchor.constraint(equalTo: leadingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: Constants.screenWidth - layoutPreferences.horizontalInsets * 2)
      ]
    case .fromRight:
      return [
        bubbleVerticalConstraint,
        bubbleView.leadingAnchor.constraint(equalTo: trailingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: Constants.screenWidth - layoutPreferences.horizontalInsets * 2)
      ]
    default:
      return []
    }
  }
  
  func createFinalBubbleConstraints() -> [NSLayoutConstraint] {
    var constraints = [
      bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: layoutPreferences.horizontalInsets),
      bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -layoutPreferences.horizontalInsets)
    ]
    
    constraints.append(bubbleVerticalConstraint)
    
    return constraints
  }
  
  func createDismissedBubbleConstraints() -> [NSLayoutConstraint] {
    let horizontalConstraintsForVerticalAnimation = [
      bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: layoutPreferences.horizontalInsets),
      bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -layoutPreferences.horizontalInsets)
    ]
    var constraints: [NSLayoutConstraint] = []
    switch animationPreferences.disappearanceAnimationType {
    case .toBottom:
      constraints.append(contentsOf: horizontalConstraintsForVerticalAnimation)
      constraints.append(bubbleView.topAnchor.constraint(equalTo: bottomAnchor))
    case .toTop:
      constraints.append(contentsOf: horizontalConstraintsForVerticalAnimation)
      constraints.append(bubbleView.bottomAnchor.constraint(equalTo: topAnchor))
    case .toRight:
      constraints = [
        bubbleVerticalConstraint,
        bubbleView.leadingAnchor.constraint(equalTo: trailingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: bounds.width - layoutPreferences.horizontalInsets * 2)
      ]
    case .toLeft:
      constraints = [
        bubbleVerticalConstraint,
        bubbleView.trailingAnchor.constraint(equalTo: leadingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: bounds.width - layoutPreferences.horizontalInsets * 2)
      ]
    default: break
    }
    
    return constraints
  }
  
  func createBubbleVerticalConstraint() -> NSLayoutConstraint {
    switch arrowPosition {
    case .top:
      return bubbleTopArrowConstraint
    default:
      return bubbleBottomArrowConstraint
    }
  }
  
  //MARK: Arrow constraints
  
  func createBubbleBottomArrowConstraint() -> NSLayoutConstraint {
    return bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -bubbleDistanceFromBottom)
  }
  
  func createBubbleTopArrowConstraint() -> NSLayoutConstraint {
    return bubbleView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: bubbleDistanceFromTop)
  }
  
  func createSizeArrowConstraints() -> [NSLayoutConstraint] {
    return [
      arrowView.widthAnchor.constraint(equalToConstant: layoutPreferences.arrowWidth),
      arrowView.heightAnchor.constraint(equalToConstant: layoutPreferences.arrowHeight)
    ]
  }
  
  func createInitialArrowConstraints() -> [NSLayoutConstraint] {
    var constraints = sizeArrowConstraints
    constraints.append(arrowView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor))
    switch arrowPosition {
    case .bottom, .any:
      constraints.append(arrowView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor))
    case .top:
      constraints.append(arrowView.bottomAnchor.constraint(equalTo: bubbleView.topAnchor))
    default: break
    }
    
    return constraints
  }
  
  func createDismissedArrowConstraints() -> [NSLayoutConstraint] {
    switch animationPreferences.disappearanceAnimationType {
    case .toRight, .toLeft:
      return initialArrowConstraints
    default:
      return finalArrowConstraints
    }
  }
  
  func createFinalArrowConstraints() -> [NSLayoutConstraint] {
    var constraints = sizeArrowConstraints
    switch arrowPosition {
    case .bottom, .any:
      constraints.append(contentsOf: arrowBottomConstraints)
    case .top:
      constraints.append(contentsOf: arrowTopConstraints)
    default: break
    }
    
    return constraints
  }
  
  func createArrowBottomConstraints() -> [NSLayoutConstraint] {
    return [
      arrowView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor),
      arrowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: centerPoint.x)
    ]
  }
  
  func createArrowTopConstraints() -> [NSLayoutConstraint] {
    return [
      arrowView.bottomAnchor.constraint(equalTo: bubbleView.topAnchor),
      arrowView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                         constant: centerPoint.x)
    ]
  }
}

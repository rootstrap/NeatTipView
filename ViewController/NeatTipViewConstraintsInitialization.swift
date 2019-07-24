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
        bubbleToArrowConstraint,
        bubbleView.trailingAnchor.constraint(equalTo: leadingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: Constants.screenWidth - layoutPreferences.horizontalInsets * 2)
      ]
    case .fromRight:
      return [
        bubbleToArrowConstraint,
        bubbleView.leadingAnchor.constraint(equalTo: trailingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: Constants.screenWidth - layoutPreferences.horizontalInsets * 2)
      ]
    default:
      return []
    }
  }
  
  func createFinalBubbleConstraints() -> [NSLayoutConstraint] {
    return arrowPosition.isVerticalArrow ?
      createFinalVerticalBubbleConstraints() :
      createFinalHorizontalBubbleConstraints()
  }
  
  func createFinalVerticalBubbleConstraints() -> [NSLayoutConstraint] {
    let centerConstraint = bubbleView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor)
    centerConstraint.priority = .defaultLow
    var constraints = [
      bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor,
                                          constant: layoutPreferences.horizontalInsets),
      bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                           constant: -layoutPreferences.horizontalInsets),
      bubbleView.leadingAnchor.constraint(lessThanOrEqualTo: arrowView.leadingAnchor, constant: -bubbleView.layer.cornerRadius),
      bubbleView.trailingAnchor.constraint(greaterThanOrEqualTo: arrowView.trailingAnchor, constant: bubbleView.layer.cornerRadius),
      centerConstraint
    ]
    
    constraints.append(bubbleToArrowConstraint)
    
    return constraints
  }
  
  func createFinalHorizontalBubbleConstraints() -> [NSLayoutConstraint] {
    let centerConstraint = bubbleView.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor)
    centerConstraint.priority = .defaultLow
    let constraints = [
      bubbleView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                      constant: layoutPreferences.verticalInsets),
      bubbleView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
                                         constant: -layoutPreferences.verticalInsets),
      bubbleView.bottomAnchor.constraint(greaterThanOrEqualTo: arrowView.bottomAnchor,
                                         constant: bubbleView.layer.cornerRadius),
      bubbleView.topAnchor.constraint(lessThanOrEqualTo: arrowView.topAnchor,
                                      constant: -bubbleView.layer.cornerRadius),
      bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant: -layoutPreferences.horizontalInsets),
      centerConstraint
    ]
    
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
        bubbleToArrowConstraint,
        bubbleView.leadingAnchor.constraint(equalTo: trailingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: bounds.width - layoutPreferences.horizontalInsets * 2)
      ]
    case .toLeft:
      constraints = [
        bubbleToArrowConstraint,
        bubbleView.trailingAnchor.constraint(equalTo: leadingAnchor),
        bubbleView.widthAnchor.constraint(equalToConstant: bounds.width - layoutPreferences.horizontalInsets * 2)
      ]
    default: break
    }
    
    return constraints
  }
  
  func createBubbleToArrowConstraint() -> NSLayoutConstraint {
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
    let widthConstraint = arrowView.widthAnchor.constraint(equalToConstant: layoutPreferences.arrowWidth)
    widthConstraint.priority = .defaultHigh
    return [
      widthConstraint,
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
    case .left:
      constraints.append(contentsOf: arrowLeftConstraints)
    default: break
    }
    
    return constraints
  }
  
  func createArrowLeftConstraints() -> [NSLayoutConstraint] {
    return [
      arrowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: arrowDistanceFromLeft),
      arrowView.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
      arrowView.topAnchor.constraint(equalTo: topAnchor, constant: centerPoint.y - layoutPreferences.arrowWidth / 2)
    ]
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

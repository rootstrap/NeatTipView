//
//  NeatViewPreferences.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/19/19.
//

import Foundation

public struct NeatViewPreferences {
  var layoutPreferences = NeatLayoutPreferences()
  var animationPreferences = NeatAnimationPreferences()
  
  public init() { }
}

public enum AppearanceAnimationType {
  case fromTop
  case fromBottom
  case fromLeft
  case fromRight
  case fadeIn
}

public enum DisappearanceAnimationType {
  case toTop
  case toBottom
  case toLeft
  case toRight
  case fadeOut
}

public struct NeatLayoutPreferences {
  var horizontalInsets: CGFloat = 20
  var verticalInsets: CGFloat = 20
  var contentHorizontalInsets: CGFloat = 10
  var contentVerticalInsets: CGFloat = 10
  var arrowWidth: CGFloat = 15
  var arrowHeight: CGFloat = 10
  
  public init() { }
}

public struct NeatAnimationPreferences {
  var animationDuration: TimeInterval = 0.3
  var appearanceAnimationType: AppearanceAnimationType = .fromBottom
  var disappearanceAnimationType: DisappearanceAnimationType = .toBottom
  
  public init() { }
}

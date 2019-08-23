//
//  NeatViewPreferences.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/19/19.
//

import Foundation

public struct NeatViewPreferences {
  public var layoutPreferences = NeatLayoutPreferences()
  public var animationPreferences = NeatAnimationPreferences()
  
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
  public var horizontalInsets: CGFloat = 20
  public var verticalInsets: CGFloat = 20
  public var contentHorizontalInsets: CGFloat = 10
  public var minWidth: CGFloat = 30
  public var contentVerticalInsets: CGFloat = 10
  public var arrowWidth: CGFloat = 15
  public var arrowHeight: CGFloat = 10
  
  public init() { }
}

public struct NeatAnimationPreferences {
  public var animationDuration: TimeInterval = 0.3
  public var appearanceAnimationType: AppearanceAnimationType = .fromBottom
  public var disappearanceAnimationType: DisappearanceAnimationType = .toBottom
  
  public init() { }
}

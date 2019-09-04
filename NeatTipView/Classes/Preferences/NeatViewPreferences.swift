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
  public var bubbleStylePreferences = NeatBubbleStylePreferences()
  public var overlayStylePreferences = NeatOverlayStylePreferences()
  
  public init() { }
}

public struct NeatBubbleStylePreferences {
  public var backgroundColor: UIColor = .white
  public var borderWidth: CGFloat = 3
  public var borderColor: UIColor = .lightGray
  public var cornerRadius: CGFloat = 8
  public var shadowColor: UIColor = .black
  public var shadowOffset = CGSize(width: 0, height: 5)
  public var shadowRadius: CGFloat = 5
  public var shadowOpacity: Float = 0.25
}

public struct NeatOverlayStylePreferences {
  public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.55)
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
  public var animationCurve: UIView.AnimationOptions = .curveEaseInOut
  public var animationOffset: CGFloat = Constants.animationOffset
  public var appearanceAnimationType: AppearanceAnimationType = .fromBottom
  public var disappearanceAnimationType: DisappearanceAnimationType = .toBottom
  
  public init() { }
}

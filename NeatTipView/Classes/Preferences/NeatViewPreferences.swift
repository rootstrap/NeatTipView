//
//  NeatViewPreferences.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/19/19.
//

import Foundation

/**
 NeatViewPreferences contains all the configurable properties for NeatTipView.
 Each property manages one aspect of the configuration properties:
  - `layoutPreferences`: Insets and arrow size.
  - `animationPreferences`: UIView animation timing, curves, etc.
  - `bubbleStylePreferences`: The visual style of the bubble itself.
  - `overlayStylePreferences`: The visual style of the background overlay.
 Each property comes with default values for easy usage.
*/
public struct NeatViewPreferences {
  public var layoutPreferences = NeatLayoutPreferences()
  public var animationPreferences = NeatAnimationPreferences()
  public var bubbleStylePreferences = NeatBubbleStylePreferences()
  public var overlayStylePreferences = NeatOverlayStylePreferences()

  public init() { }
}

/// Bubble view style properties
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

/// Overlay style properties
public struct NeatOverlayStylePreferences {
  public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.55)
}

/**
 AppearanceAnimationType defines all available appearance animations,
 this will define how the View is presented each time `.show()` is called
*/
public enum AppearanceAnimationType {
  case fromTop
  case fromBottom
  case fromLeft
  case fromRight
  case fadeIn
}

/**
 AppearanceAnimationType defines all available dismiss animations,
 this will define how the View is presented each time `.dismiss()` is called
 */
public enum DisappearanceAnimationType {
  case toTop
  case toBottom
  case toLeft
  case toRight
  case fadeOut
}

/// View layout properties
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

/// Animation preferences, applies both for appearance and dissapearance
public struct NeatAnimationPreferences {
  public var animationDuration: TimeInterval = 0.3
  public var animationCurve: UIView.AnimationOptions = .curveEaseInOut
  public var animationOffset: CGFloat = Constants.animationOffset
  public var appearanceAnimationType: AppearanceAnimationType = .fromBottom
  public var disappearanceAnimationType: DisappearanceAnimationType = .toBottom

  public init() { }
}

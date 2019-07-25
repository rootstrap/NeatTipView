//
//  NeatExampleViewController.swift
//  NeatTipView_Example
//
//  Created by Germán Stábile on 7/19/19.
//  Copyright © 2019 Rootstrap. All rights reserved.
//

import NeatTipView
import UIKit

class NeatExampleViewController: UIViewController {
  
  @IBAction func fromLeftButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromLeft
    preferences.animationPreferences.disappearanceAnimationType = .toRight
    let point = CGPoint(x: sender.frame.minX, y: sender.center.y)
    showTipView(with: preferences, center: point, arrowPosition: .bottom)
  }
  
  @IBAction func fromRightButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromRight
    preferences.animationPreferences.disappearanceAnimationType = .toLeft
    showTipView(with: preferences, center: sender.center, arrowPosition: .top)
  }
  
  @IBAction func fromBottomButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromBottom
    preferences.animationPreferences.disappearanceAnimationType = .toTop
    showTipView(with: preferences, center: sender.center, arrowPosition: .right)
  }
  
  @IBAction func fromTopButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromTop
    preferences.animationPreferences.disappearanceAnimationType = .toBottom
    showTipView(with: preferences, center: sender.center, arrowPosition: .left)
  }
  
  func showTipView(with preferences: NeatViewPreferences,
                   center: CGPoint,
                   arrowPosition: ArrowPosition) {
    let tipView = NeatTipView(superview: view,
                              centerPoint: center,
                              attributedString: attributedString(),
                              preferences: preferences,
                              arrowPosition: arrowPosition)
    tipView.show()
  }
  
  func attributedString() -> NSAttributedString {
    let attributedString =
      NSMutableAttributedString(string: "This is an example of one of the neat tips you can present using NeatTipView. This is an example of one of the neat tips you can present using NeatTipView. This is an example of one of the neat tips you can present using NeatTipView. This is an example of one of the neat tips you can present using NeatTipView. This is an example of one of the neat tips you can present using NeatTipView. This is an example of one of the neat tips you can present using NeatTipViewv un par de boludeces mas",
                                attributes: [.font: UIFont.systemFont(ofSize: 15)])
    attributedString.highlight(text: "NeatTipView",
                               with: [.font: UIFont.systemFont(ofSize: 15,
                                                               weight: .bold)])
    
    return attributedString
  }
}

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
    preferences.animationPreferences.disappearanceAnimationType = .toLeft
    showTipView(with: preferences,
                center: sender.center,
                arrowPosition: .right)
  }
  
  @IBAction func fromRightButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromRight
    preferences.animationPreferences.disappearanceAnimationType = .toRight
    preferences.bubbleStylePreferences.backgroundColor = .greeny
    preferences.bubbleStylePreferences.borderColor = .cadetBlue
    showTipView(with: preferences,
                center: sender.center,
                arrowPosition: .left,
                attributedText: neatAttributedString())
  }
  
  @IBAction func fromBottomButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromBottom
    preferences.animationPreferences.disappearanceAnimationType = .toBottom
    showTipView(with: preferences, center: sender.center, arrowPosition: .top)
  }
  
  @IBAction func fromTopButtonTapped(sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.animationPreferences.appearanceAnimationType = .fromTop
    preferences.animationPreferences.disappearanceAnimationType = .toTop
    preferences.bubbleStylePreferences.backgroundColor = .purply
    showTipView(with: preferences, center: sender.center, arrowPosition: .bottom, attributedText: neatAttributedString())
  }
  
  @IBAction func attachToButtonTapped(_ sender: UIButton) {
    var preferences = NeatViewPreferences()
    preferences.bubbleStylePreferences.backgroundColor = UIColor.paleRose
    NeatTipView.attach(to: sender, in: view,
                       with: diversityAttributedString(),
                       preferences: preferences,
                       arrowPosition: .top)
  }

  func showTipView(with preferences: NeatViewPreferences,
                   center: CGPoint,
                   arrowPosition: ArrowPosition,
                   attributedText: NSAttributedString? = nil) {
    let tipView = NeatTipView(superview: view,
                              centerPoint: center,
                              attributedString: attributedText ?? attributedString(),
                              preferences: preferences,
                              arrowPosition: arrowPosition)
    tipView.show()
  }
  
  func attributedString() -> NSAttributedString {
    let attributedString =
      NSMutableAttributedString(string: "This is an example of one of the neat tips you can create with NeatTipView",
                                attributes: [.font: UIFont.systemFont(ofSize: 15)])
    attributedString.highlight(text: "NeatTipView",
                               with: [.font: UIFont.systemFont(ofSize: 15,
                                                               weight: .bold)])
    
    return attributedString
  }
  
  func diversityAttributedString() -> NSAttributedString {
    let coloredWords: [(UIColor, String)] =
      [(UIColor.red, "This "), (UIColor.orange, "is a "),
       (UIColor.gold, "diverse "), (UIColor.green, "Neat "),
       (UIColor.blue, "Tip "), (UIColor.purple, "View ")]
    
    let attributedString = NSMutableAttributedString()
    
    coloredWords.forEach {
     attributedString.append(
      NSAttributedString(string: $0.1,
                         attributes: [.strokeColor: UIColor.black,
                                      .foregroundColor: $0.0,
                                      .font: UIFont.systemFont(ofSize: 14, weight: .bold)])
      )
    }
    
    return attributedString
  }
  
  func neatAttributedString() -> NSAttributedString {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    paragraph.lineHeightMultiple = 0.8
    
    let attributedString = NSMutableAttributedString(
      string: "100",
      attributes: [
        .font: UIFont.systemFont(ofSize: 26, weight: .semibold),
        .foregroundColor: UIColor.white,
        .paragraphStyle: paragraph]
    )
    attributedString.append(
      NSAttributedString(
        string: "%\n",
        attributes: [
          .font: UIFont.systemFont(ofSize: 14,
                                   weight: .medium),
          .foregroundColor: UIColor.white,
          .baselineOffset: 8
        ]
      )
    )
    attributedString.append(
      NSAttributedString(
        string: "NEAT TIPS",
        attributes: [
          .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
          .foregroundColor: UIColor.white,
          .paragraphStyle: paragraph
        ]
      )
    )
    
    return attributedString
  }
}

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
  
  @IBAction func infoButtonTapped(sender: UIButton) {
    let tipView = NeatTipView(centerPoint: sender.center,
                              attributedString: attributedString(),
                              arrowPosition: .top)
    tipView.show(in: view)
  }
  
  func attributedString() -> NSAttributedString {
    let attributedString =
      NSMutableAttributedString(string: "This is an example of one of the neat tips you can present using NeatTipView",
                                attributes: [.font: UIFont.systemFont(ofSize: 15)])
    attributedString.highlight(text: "NeatTipView",
                               with: [.font: UIFont.systemFont(ofSize: 15,
                                                               weight: .bold)])
    
    return attributedString
  }
}

//
//  TipViewController.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

public enum ArrowPosition {
  case top
  case bottom
  case left
  case right
  case any
}

public struct Preferences {
  var horizontalInsets: CGFloat = 20
  var verticalInsets: CGFloat = 20
  var contentHorizontalInsets: CGFloat = 10
  var contentVerticalInsets: CGFloat = 10
  var arrowWidth: CGFloat = 15
  var arrowHeight: CGFloat = 10
  
  var animationDuration: TimeInterval = 0.3
  
  public init() { }
}

struct Constants {
  static let screenWidth = UIScreen.main.bounds.width
  static let screenHeight = UIScreen.main.bounds.height
}

public class NeatTipViewController: UIViewController {
  
  public var centerPoint: CGPoint
  public var arrowPosition: ArrowPosition
  public var preferences: Preferences
  public var attributedString: NSAttributedString
  
  lazy var bubbleView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 8
    
    return view
  }()
  
  lazy var backgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    view.alpha = 0
    
    return view
  }()
  
  lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var arrowView: NeatArrowView = {
    let arrow = NeatArrowView()
    arrow.translatesAutoresizingMaskIntoConstraints = false
    
    return arrow
  }()
  
  var distanceFromBottom: CGFloat {
    return view.bounds.height - centerPoint.y +
      preferences.verticalInsets + preferences.arrowHeight
  }
  
  public init(centerPoint: CGPoint,
              attributedString: NSAttributedString,
              preferences: Preferences = Preferences(),
              arrowPosition: ArrowPosition = .any) {
    self.centerPoint = centerPoint
    self.attributedString = attributedString
    self.preferences = preferences
    self.arrowPosition = arrowPosition
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.backgroundView.alpha = 1
    })
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
  }
  
  func configureViews() {
    addSubviews()
    label.attributedText = attributedString
    activateConstraints()
    addDismissGesture()
  }
  
  func addDismissGesture() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(dismissTip))
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc
  func dismissTip() {
    dismiss(animated: true)
  }
  
  public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: preferences.animationDuration,
                   animations: { [weak self] in
                    self?.backgroundView.alpha = 0
                   },
                   completion: { _ in
                    super.dismiss(animated: true)
                   })
  }
  func addSubviews() {
    view.backgroundColor = .clear
    view.addSubview(backgroundView)
    view.addSubview(bubbleView)
    bubbleView.addSubview(label)
    view.bringSubviewToFront(bubbleView)
    view.addSubview(arrowView)
  }
  
  func activateConstraints() {
    NSLayoutConstraint.activate([
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      bubbleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: preferences.horizontalInsets),
      bubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -preferences.horizontalInsets),
      bubbleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -distanceFromBottom),
      
      arrowView.widthAnchor.constraint(equalToConstant: preferences.arrowWidth),
      arrowView.heightAnchor.constraint(equalToConstant: preferences.arrowHeight),
      arrowView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor),
      arrowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: centerPoint.x),
      
      label.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor,
                                     constant: preferences.contentHorizontalInsets),
      label.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor,
                                      constant: -preferences.contentHorizontalInsets),
      label.topAnchor.constraint(equalTo: bubbleView.topAnchor,
                                 constant: preferences.verticalInsets),
      label.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor,
                                    constant: -preferences.verticalInsets)
      ])
  }
}

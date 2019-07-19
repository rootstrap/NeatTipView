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

struct Constants {
  static let screenWidth = UIScreen.main.bounds.width
  static let screenHeight = UIScreen.main.bounds.height
}

public class NeatTipViewController: UIViewController {
  
  public var centerPoint: CGPoint
  public var arrowPosition: ArrowPosition
  public var preferences: NeatViewPreferences
  public var attributedString: NSAttributedString
  
  var layoutPreferences: NeatLayoutPreferences {
    return preferences.layoutPreferences
  }
  
  var animationPreferences: NeatAnimationPreferences {
    return preferences.animationPreferences
  }
  
  lazy var bubbleView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
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
    let arrow = NeatArrowView(with: arrowPosition)
    arrow.translatesAutoresizingMaskIntoConstraints = false
    
    return arrow
  }()
  
  lazy var bubbleConstraints: [NSLayoutConstraint] = {
    var constraints = [
      bubbleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: layoutPreferences.horizontalInsets),
      bubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -layoutPreferences.horizontalInsets)
    ]
    
    switch arrowPosition {
    case .top:
      constraints.append(bubbleTopArrowConstraint)
    default:
      constraints.append(bubbleBottomArrowConstraint)
    }
    
    return constraints
    
  }()
  
  lazy var bubbleBottomArrowConstraint: NSLayoutConstraint = {
    return bubbleView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: -bubbleDistanceFromBottom)
  }()
  
  lazy var bubbleTopArrowConstraint: NSLayoutConstraint = {
    return bubbleView.topAnchor.constraint(equalTo: view.topAnchor,
                                           constant: bubbleDistanceFromTop)
  }()
  
  lazy var arrowConstraints: [NSLayoutConstraint] = {
    var constraints = [
      arrowView.widthAnchor.constraint(equalToConstant: layoutPreferences.arrowWidth),
      arrowView.heightAnchor.constraint(equalToConstant: layoutPreferences.arrowHeight)
    ]
    switch arrowPosition {
    case .bottom, .any:
      constraints.append(contentsOf: arrowBottomConstraints)
    case .top:
      constraints.append(contentsOf: arrowTopConstraints)
    default: break
    }
    
    return constraints
  }()
  
  lazy var arrowBottomConstraints: [NSLayoutConstraint] = {
    return [
      arrowView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor),
      arrowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: centerPoint.x)
    ]
  }()
  
  lazy var arrowTopConstraints: [NSLayoutConstraint] = {
    return [
      arrowView.bottomAnchor.constraint(equalTo: bubbleView.topAnchor),
      arrowView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                         constant: centerPoint.x)
    ]
  }()
  
  var bubbleDistanceFromBottom: CGFloat {
    
    return view.bounds.height - centerPoint.y +
      layoutPreferences.verticalInsets + layoutPreferences.arrowHeight
  }
  
  var bubbleDistanceFromTop: CGFloat {
    return centerPoint.y + layoutPreferences.arrowHeight +
      layoutPreferences.verticalInsets
  }
  
  public init(centerPoint: CGPoint,
              attributedString: NSAttributedString,
              preferences: NeatViewPreferences = NeatViewPreferences(),
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
    UIView.animate(withDuration: animationPreferences.animationDuration,
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
    var constraints = [
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      label.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor,
                                     constant: layoutPreferences.contentHorizontalInsets),
      label.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor,
                                      constant: -layoutPreferences.contentHorizontalInsets),
      label.topAnchor.constraint(equalTo: bubbleView.topAnchor,
                                 constant: layoutPreferences.verticalInsets),
      label.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor,
                                    constant: -layoutPreferences.verticalInsets)
      ]
    
    constraints.append(contentsOf: bubbleConstraints)
    constraints.append(contentsOf: arrowConstraints)
    
    NSLayoutConstraint.activate(constraints)
  }
}

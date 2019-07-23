//
//  NeatTipView.swift
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

public class NeatTipView: UIView {
  
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
  
  //MARK: Views initialization
  
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
  
  //MARK: constraints initialization
  
  lazy var finalBubbleConstraints: [NSLayoutConstraint] = createFinalBubbleConstraints()
  
  lazy var bubbleVerticalConstraint: NSLayoutConstraint = createBubbleVerticalConstraint()
  
  lazy var initialBubbleConstraints: [NSLayoutConstraint] = createInitialBubbleConstraints()
  
  lazy var bubbleBottomArrowConstraint: NSLayoutConstraint = createBubbleBottomArrowConstraint()
  
  lazy var bubbleTopArrowConstraint: NSLayoutConstraint = createBubbleTopArrowConstraint()
  
  lazy var sizeArrowConstraints: [NSLayoutConstraint] = createSizeArrowConstraints()
  
  lazy var finalArrowConstraints: [NSLayoutConstraint] = createFinalArrowConstraints()
  
  lazy var initialArrowConstraints: [NSLayoutConstraint] = createInitialArrowConstraints()
  
  lazy var arrowBottomConstraints: [NSLayoutConstraint] = createArrowBottomConstraints()
  
  lazy var arrowTopConstraints: [NSLayoutConstraint] = createArrowTopConstraints()
  
  var bubbleDistanceFromBottom: CGFloat {
    //for initial constraints the bound is zero for smoother animations assume the superview is as big as the screen
    let viewHeight = bounds.height == 0 ? Constants.screenHeight : bounds.height
    return viewHeight - centerPoint.y +
      layoutPreferences.verticalInsets + layoutPreferences.arrowHeight
  }
  
  var bubbleDistanceFromTop: CGFloat {
    return centerPoint.y + layoutPreferences.arrowHeight +
      layoutPreferences.verticalInsets
  }
  
  //MARK: APIs
  
  public init(centerPoint: CGPoint,
              attributedString: NSAttributedString,
              preferences: NeatViewPreferences = NeatViewPreferences(),
              arrowPosition: ArrowPosition = .any) {
    self.centerPoint = centerPoint
    self.attributedString = attributedString
    self.preferences = preferences
    self.arrowPosition = arrowPosition
    super.init(frame: CGRect.zero)
    configureViews()
  }
  
  public func show(in superview: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    superview.addSubview(self)
    
    NSLayoutConstraint.activate([
      superview.topAnchor.constraint(equalTo: topAnchor),
      superview.leadingAnchor.constraint(equalTo: leadingAnchor),
      superview.trailingAnchor.constraint(equalTo: trailingAnchor),
      superview.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
    
    setNeedsLayout()
    layoutIfNeeded()
    //refreshing constraints that depend on the superview frame
    bubbleBottomArrowConstraint.constant = -bubbleDistanceFromBottom
    
    //animating views on appearance
    NSLayoutConstraint.deactivate(initialArrowConstraints)
    NSLayoutConstraint.deactivate(initialBubbleConstraints)
    NSLayoutConstraint.activate(finalBubbleConstraints)
    NSLayoutConstraint.activate(finalArrowConstraints)
    UIView.animate(withDuration: animationPreferences.animationDuration,
                   animations: { [weak self] in
                    self?.layoutIfNeeded()
                   })
  }
  
  //MARK: View lifecycle
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.backgroundView.alpha = 1
    })
  }
  
  //MARK: Views configuration
  
  fileprivate func configureViews() {
    addSubviews()
    label.attributedText = attributedString
    activateConstraints()
    addDismissGesture()
  }
  
  fileprivate func addDismissGesture() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(dismissTip))
    addGestureRecognizer(tapGesture)
  }
  
  @objc
  func dismissTip() {
    UIView.animate(withDuration: animationPreferences.animationDuration,
                   animations: { [weak self] in
                    self?.backgroundView.alpha = 0
                   },
                   completion: { [weak self] _ in
                    self?.removeFromSuperview()
                   })
  }
  
  fileprivate func addSubviews() {
    backgroundColor = .clear
    addSubview(backgroundView)
    addSubview(bubbleView)
    bubbleView.addSubview(label)
    bringSubviewToFront(bubbleView)
    addSubview(arrowView)
  }
  
  fileprivate func activateConstraints() {
    var constraints = [
      backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      label.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor,
                                     constant: layoutPreferences.contentHorizontalInsets),
      label.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor,
                                      constant: -layoutPreferences.contentHorizontalInsets),
      label.topAnchor.constraint(equalTo: bubbleView.topAnchor,
                                 constant: layoutPreferences.verticalInsets),
      label.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor,
                                    constant: -layoutPreferences.verticalInsets)
      ]
    
    constraints.append(contentsOf: initialBubbleConstraints)
    constraints.append(contentsOf: initialArrowConstraints)
    
    NSLayoutConstraint.activate(constraints)
  }
}

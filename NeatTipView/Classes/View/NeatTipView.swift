//
//  NeatTipView.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

struct Constants {
  static let screenWidth = UIScreen.main.bounds.width
  static let screenHeight = UIScreen.main.bounds.height
}

public class NeatTipView: UIView {
  public var arrowPosition: ArrowPosition
  public var preferences: NeatViewPreferences
  public var parentView: UIView
  
  var layoutPreferences: NeatLayoutPreferences {
    return preferences.layoutPreferences
  }
  
  var animationPreferences: NeatAnimationPreferences {
    return preferences.animationPreferences
  }
  
  //MARK: Views initialization
  
  var bubbleView: BubbleView

  lazy var backgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    view.alpha = 0
    
    return view
  }()
  
  //MARK: constraints initialization
  
  lazy var bubbleConstraints: [NSLayoutConstraint] = createBubbleConstraints()
  
  var bubbleDistanceFromBottom: CGFloat {
    //for initial constraints the bound is zero for smoother animations assume the superview is as big as the screen
    let viewHeight = bounds.height == 0 ? Constants.screenHeight : bounds.height
    return viewHeight - bubbleView.centerPoint.y +
      layoutPreferences.verticalInsets + layoutPreferences.arrowHeight
  }
  
  var bubbleDistanceFromTop: CGFloat {
    return bubbleView.centerPoint.y + layoutPreferences.arrowHeight +
      layoutPreferences.verticalInsets
  }

  var bubblePositionConstraints: [NSLayoutConstraint] {
    switch arrowPosition {
    case .any, .top:
      return [
        bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: bubbleView.centerPoint.y + layoutPreferences.contentVerticalInsets),
        bubbleView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
      ]
    case .bottom:
      return [
        bubbleView.bottomAnchor.constraint(equalTo: topAnchor, constant: bubbleView.centerPoint.y - layoutPreferences.contentVerticalInsets),
      ]
    case .left:
      return [
        bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bubbleView.centerPoint.x + layoutPreferences.contentHorizontalInsets),
        centerBubbleConstraint
      ]
    case .right:
      return [
        bubbleView.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bubbleView.centerPoint.x + layoutPreferences.contentHorizontalInsets),
        centerBubbleConstraint
      ]
    }
  }

  var centerBubbleConstraint: NSLayoutConstraint {
    let availableWidth = bubbleView.centerPoint.x -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2 -
      layoutPreferences.arrowHeight

    let size = bubbleView.attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))

    let offset =  max(bubbleView.centerPoint.y - size.height + layoutPreferences.contentVerticalInsets, 0)
    return bubbleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offset)
  }
  
  //MARK: APIs
  
  public init(superview: UIView,
              centerPoint: CGPoint,
              attributedString: NSAttributedString,
              preferences: NeatViewPreferences = NeatViewPreferences(),
              arrowPosition: ArrowPosition = .top) {
    self.preferences = preferences
    self.arrowPosition = arrowPosition == .any ? .top : arrowPosition
    self.parentView = superview
    bubbleView = BubbleView(
      with: superview,
      and: centerPoint,
      message: attributedString,
      preferences: preferences,
      arrowPosition: arrowPosition
    )

    super.init(frame: .zero)
    
    if let position = whereDoesItFit(in: superview, preferredPosition: arrowPosition) {
      self.arrowPosition = position
      bubbleView.arrowPosition = position
    }
    
    configureViews()
  }
  
  public func show() {
    translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(self)

    var constraints = [
      parentView.topAnchor.constraint(equalTo: topAnchor),
      parentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      parentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      parentView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]

    constraints.append(contentsOf: bubblePositionConstraints)

    NSLayoutConstraint.activate(constraints)
    bubbleView.setNeedsDisplay()
    bubbleView.layoutIfNeeded()
    setNeedsLayout()
    layoutIfNeeded()
    
    UIView.animate(
      withDuration: animationPreferences.animationDuration,
      animations: { [weak self] in
        self?.layoutIfNeeded()
      }
    )
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
  
  private func configureViews() {
    addSubviews()
    activateConstraints()
    addDismissGesture()
  }
  
  private func addDismissGesture() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(dismissTip))
    addGestureRecognizer(tapGesture)
  }
  
  @objc
  func dismissTip() {
    UIView.animate(withDuration: animationPreferences.animationDuration,
                   animations: { [weak self] in
                    self?.alpha = 0
                   },
                   completion: { [weak self] _ in
                    self?.removeFromSuperview()
                   })
  }
  
  private func addSubviews() {
    backgroundColor = .clear
    addSubview(backgroundView)
    addSubview(bubbleView)
    bringSubviewToFront(bubbleView)
  }
  
  private func activateConstraints() {
    var constraints = [
      backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]
    
    constraints.append(contentsOf: bubbleConstraints)
    
    NSLayoutConstraint.activate(constraints)
  }
}

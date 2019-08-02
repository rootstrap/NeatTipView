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
  
  var isVerticalArrow: Bool {
    return self == .top || self == .bottom
  }
  
  var counterpart: ArrowPosition {
    switch self {
    case .left:
      return .right
    case .right:
      return .left
    case .top:
      return .bottom
    case .bottom:
      return .top
    default:
      return .any
    }
  }
  
  static var verticalPositions: [ArrowPosition] {
    return [.top, .bottom]
  }
  
  static var horizontalPositions: [ArrowPosition] {
    return [.left, .right]
  }
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
  var tipSuperview: UIView
  
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
  
  lazy var bubbleConstraints: [NSLayoutConstraint] = createBubbleConstraints()
  
  lazy var bubbleToArrowConstraint: NSLayoutConstraint = createBubbleToArrowConstraint()
  
  lazy var bubbleBottomArrowConstraint: NSLayoutConstraint = createBubbleBottomArrowConstraint()
  
  lazy var bubbleTopArrowConstraint: NSLayoutConstraint = createBubbleTopArrowConstraint()
  
  lazy var sizeArrowConstraints: [NSLayoutConstraint] = createSizeArrowConstraints()
  
  lazy var arrowConstraints: [NSLayoutConstraint] = createArrowConstraints()
  
  lazy var arrowBottomConstraints: [NSLayoutConstraint] = createArrowBottomConstraints()
  
  lazy var arrowLeftConstraints: [NSLayoutConstraint] = createArrowLeftConstraints()
  
  lazy var arrowRightConstraints: [NSLayoutConstraint] = createArrowRightConstraints()
  
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
  
  var arrowDistanceFromLeft: CGFloat {
    return centerPoint.x + layoutPreferences.horizontalInsets - layoutPreferences.arrowHeight
  }
  
  var arrowDistanceFromRight: CGFloat {
    return tipSuperview.bounds.width - centerPoint.x + layoutPreferences.horizontalInsets
  }
  
  //MARK: APIs
  
  public init(superview: UIView,
              centerPoint: CGPoint,
              attributedString: NSAttributedString,
              preferences: NeatViewPreferences = NeatViewPreferences(),
              arrowPosition: ArrowPosition = .top) {
    self.centerPoint = centerPoint
    self.attributedString = attributedString
    self.preferences = preferences
    self.arrowPosition = arrowPosition == .any ? .top : arrowPosition
    tipSuperview = superview
    super.init(frame: CGRect.zero)
    
    if let position = whereDoesItFit(in: superview, preferredPosition: arrowPosition) {
      self.arrowPosition = position
    }
    
    configureViews()
  }
  
  public func show() {
    translatesAutoresizingMaskIntoConstraints = false
    tipSuperview.addSubview(self)
    
    NSLayoutConstraint.activate([
      tipSuperview.topAnchor.constraint(equalTo: topAnchor),
      tipSuperview.leadingAnchor.constraint(equalTo: leadingAnchor),
      tipSuperview.trailingAnchor.constraint(equalTo: trailingAnchor),
      tipSuperview.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
    
    setNeedsLayout()
    layoutIfNeeded()
    
    //refreshing constraints that depend on the superview frame
    bubbleBottomArrowConstraint.constant = -bubbleDistanceFromBottom
    
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
  
  private func configureViews() {
    addSubviews()
    label.attributedText = attributedString
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
    bubbleView.addSubview(label)
    bringSubviewToFront(bubbleView)
    addSubview(arrowView)
  }
  
  private func tipFits(in superview: UIView, for arrowPosition: ArrowPosition) -> Bool {
    let availableWidth = superview.bounds.width -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2
    let availableHeight = superview.bounds.height -
      superview.safeAreaInsets.bottom - superview.safeAreaInsets.top -
      (layoutPreferences.verticalInsets + layoutPreferences.contentVerticalInsets) * 2
    
    switch arrowPosition {
    case .bottom:
      return fitsAtTop(in: superview, with: availableWidth)
    case .top:
      return fitsAtBottom(in: superview, with: availableWidth)
    case .left:
      return fitsInRight(in: superview, with: availableHeight)
    case .right:
      return fitsInLeft(in: superview, with: availableHeight)
    default:
      return false
    }
  }
  
  private func fitsAtBottom(in superview: UIView, with availableWidth: CGFloat) -> Bool {
    let availableHeight = superview.bounds.height - superview.safeAreaInsets.bottom - centerPoint.y -
      (layoutPreferences.verticalInsets + layoutPreferences.contentVerticalInsets) * 2 -
      layoutPreferences.arrowHeight
    
    let size = attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))
    
    return availableHeight > size.height
  }
  
  private func fitsAtTop(in superview: UIView, with availableWidth: CGFloat) -> Bool {
    let availableHeight = centerPoint.y - superview.safeAreaInsets.top -
      (layoutPreferences.verticalInsets + layoutPreferences.contentVerticalInsets) * 2 -
      layoutPreferences.arrowHeight
    
    let size = attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))
    
    return availableHeight > size.height
  }
  
  private func fitsInRight(in superview: UIView, with availableHeight: CGFloat) -> Bool {
    let availableWidth = superview.bounds.width - centerPoint.x -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2 -
      layoutPreferences.arrowHeight
    
    guard availableWidth > layoutPreferences.minWidth else { return false }
    
    let size = attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))
    
    return availableHeight > size.height
  }
  
  private func fitsInLeft(in superview: UIView, with availableHeight: CGFloat) -> Bool {
    let availableWidth = centerPoint.x -
      (layoutPreferences.horizontalInsets + layoutPreferences.contentHorizontalInsets) * 2 -
      layoutPreferences.arrowHeight
    
    guard availableWidth > layoutPreferences.minWidth else { return false }
    
    let size = attributedString.size(with: CGSize(width: availableWidth,
                                                  height: CGFloat.greatestFiniteMagnitude))
    
    return availableHeight > size.height
  }
  
  private func whereDoesItFit(in superview: UIView,
                                  preferredPosition: ArrowPosition) -> ArrowPosition? {
    if tipFits(in: superview, for: preferredPosition) {
      return preferredPosition
    } else if tipFits(in: superview, for: preferredPosition.counterpart) {
      return preferredPosition.counterpart
    }
    
    let remainingPositions = preferredPosition.isVerticalArrow ?
      ArrowPosition.horizontalPositions :
      ArrowPosition.verticalPositions
    
    return remainingPositions.first { tipFits(in: superview, for: $0) }
  }
  
  private func activateConstraints() {
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
    
    constraints.append(contentsOf: bubbleConstraints)
    constraints.append(contentsOf: arrowConstraints)
    
    NSLayoutConstraint.activate(constraints)
  }
}

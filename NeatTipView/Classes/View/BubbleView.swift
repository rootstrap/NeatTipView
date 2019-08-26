//
//  BubbleView.swift
//  NeatTipView
//
//  Created by Mauricio Cousillas on 8/23/19.
//

import UIKit

public class BubbleView: UIView {
  public var parentView: UIView?
  public var centerPoint: CGPoint
  public var preferences: NeatViewPreferences
  public var attributedString: NSAttributedString
  private var activeConstraints: [NSLayoutConstraint] = []

  var layoutPreferences: NeatLayoutPreferences {
    return preferences.layoutPreferences
  }

  var animationPreferences: NeatAnimationPreferences {
    return preferences.animationPreferences
  }

  public var arrowPosition: ArrowPosition {
    didSet {
      clearConstraints()
      activateConstraints()
      setNeedsDisplay()
      layoutIfNeeded()
    }
  }

  lazy var contentContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    view.backgroundColor = .clear

    return view
  }()

  lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = attributedString.string

    return label
  }()


  public init(with parentView: UIView,
              and centerPoint: CGPoint,
              message attributedString: NSAttributedString,
              preferences: NeatViewPreferences = NeatViewPreferences(),
              arrowPosition: ArrowPosition = .top) {
    self.centerPoint = centerPoint
    self.attributedString = attributedString
    self.preferences = preferences
    self.arrowPosition = arrowPosition == .any ? .top : arrowPosition
    self.parentView = parentView
    self.preferences = preferences
    super.init(frame: .zero)
    
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    arrowPosition = .bottom
    preferences = NeatViewPreferences()
    arrowPosition = .top
    parentView = nil
    centerPoint = .zero
    attributedString = NSAttributedString(string: "")
    super.init(coder: aDecoder)
    setupViews()
  }

  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    let arrowPath = NeatArrowPath(
      position: arrowPosition,
      center: centerPoint,
      width: layoutPreferences.arrowWidth,
      height: layoutPreferences.arrowHeight,
      frame: frame
    ).path

    UIColor.white.setFill()
    UIColor.white.setStroke()

    arrowPath.append(UIBezierPath(roundedRect: contentContainerView.frame, cornerRadius: 8))

    arrowPath.fill()
    arrowPath.stroke()
  }

  private func setupViews() {
    addSubview(contentContainerView)
    contentContainerView.addSubview(label)
    activateConstraints()
  }

  private func activateConstraints() {
    activeConstraints = [
      contentContainerView.topAnchor.constraint(equalTo: topAnchor, constant: arrowPosition == .top ? layoutPreferences.arrowHeight : 0),
      contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: arrowPosition == .bottom ? -layoutPreferences.arrowHeight : 0),
      contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: arrowPosition == .left ? layoutPreferences.arrowHeight : 0),
      contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: arrowPosition == .right ? -layoutPreferences.arrowHeight : 0),
      label.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor,
                                     constant: layoutPreferences.contentHorizontalInsets),
      label.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor,
                                      constant: -layoutPreferences.contentHorizontalInsets),
      label.topAnchor.constraint(equalTo: contentContainerView.topAnchor,
                                 constant: layoutPreferences.verticalInsets),
      label.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor,
                                    constant: -layoutPreferences.verticalInsets)
    ]

    NSLayoutConstraint.activate(activeConstraints)
  }

  private func clearConstraints() {
    NSLayoutConstraint.deactivate(activeConstraints)
    activeConstraints = []
  }
}

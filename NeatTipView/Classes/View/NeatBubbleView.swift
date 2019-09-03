//
//  BubbleView.swift
//  NeatTipView
//
//  Created by Mauricio Cousillas on 8/23/19.
//

import UIKit

public class NeatBubbleView: UIView {
  public var preferences: NeatViewPreferences
  public var attributedString: NSAttributedString
  private var activeConstraints: [NSLayoutConstraint] = []

  var layoutPreferences: NeatLayoutPreferences {
    return preferences.layoutPreferences
  }

  var stylePreferences: NeatBubbleStylePreferences {
    return preferences.bubbleStylePreferences
  }

  public var centerPoint: CGPoint {
    didSet {
      setNeedsDisplay()
      layoutIfNeeded()
    }
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
    view.backgroundColor = .clear
    view.layer.masksToBounds = false

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


  public init(
    with centerPoint: CGPoint,
    message attributedString: NSAttributedString,
    preferences: NeatViewPreferences = NeatViewPreferences(),
    arrowPosition: ArrowPosition = .top
  ) {
    self.centerPoint = centerPoint
    self.attributedString = attributedString
    self.preferences = preferences
    self.arrowPosition = arrowPosition == .any ? .top : arrowPosition
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
      frame: frame,
      borderOffset: stylePreferences.borderWidth
    ).path

    let path = UIBezierPath(
      roundedRect: contentContainerView.frame.insetBy(
        dx: stylePreferences.borderWidth,
        dy: stylePreferences.borderWidth
      ),
      cornerRadius: preferences.bubbleStylePreferences.cornerRadius
    )

    stylePreferences.backgroundColor.setFill()
    stylePreferences.borderColor.setStroke()
    path.lineWidth = stylePreferences.borderWidth

    path.append(arrowPath)

    path.close()
    path.stroke()
    path.fill()

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

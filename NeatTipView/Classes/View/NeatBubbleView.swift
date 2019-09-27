//
//  BubbleView.swift
//  NeatTipView
//
//  Created by Mauricio Cousillas on 8/23/19.
//

import UIKit

/**
 NeatBubbleView renders the actual tooltip using the defined preferences and string.
 You can use this view without depending on `NeatTipView` if you need something custom,
 or you don't want a full-screen overlay.
*/
public class NeatBubbleView: UIView {
  /// Configuration preferences.
  public var preferences: NeatViewPreferences
  /// The string to be displayed
  public var attributedString: NSAttributedString
  /// Active constraints for the content of the bubble.
  private var activeConstraints: [NSLayoutConstraint] = []

  var layoutPreferences: NeatLayoutPreferences {
    return preferences.layoutPreferences
  }

  var stylePreferences: NeatBubbleStylePreferences {
    return preferences.bubbleStylePreferences
  }

  /// Point used to center the tip of the bubble's arrow. Redraws if changed.
  public var centerPoint: CGPoint {
    didSet {
      setNeedsDisplay()
      layoutIfNeeded()
    }
  }

  /// Arrow's position. Re-calculates layout constraints if changed.
  public var arrowPosition: ArrowPosition {
    didSet {
      clearConstraints()
      activateConstraints()
      setNeedsDisplay()
      layoutIfNeeded()
    }
  }

  /// Wrapper view used to contain the actual content displayed by the user.
  lazy var contentContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.layer.masksToBounds = false

    return view
  }()

  /// Label used to render the actual attributed string.
  lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    label.attributedText = attributedString

    return label
  }()

  /// Programatic view initialization
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

  /// View intialization called when using xibs with sane defaults.
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

    layer.shadowColor = stylePreferences.shadowColor.cgColor
    layer.shadowOffset = stylePreferences.shadowOffset
    layer.shadowRadius = stylePreferences.shadowRadius
    layer.shadowOpacity = stylePreferences.shadowOpacity

    layer.masksToBounds = false
    
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

  /// View setup.
  private func setupViews() {
    addSubview(contentContainerView)
    contentContainerView.addSubview(label)
    activateConstraints()
  }

  /// Constraints setup.
  private func activateConstraints() {
    activeConstraints = [
      contentContainerView.topAnchor.constraint(equalTo: topAnchor, constant: arrowPosition == .top ? layoutPreferences.arrowHeight : 0),
      contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: arrowPosition == .bottom ? -layoutPreferences.arrowHeight : 0),
      contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: arrowPosition == .left ? layoutPreferences.arrowHeight : 0),
      contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: arrowPosition == .right ? -layoutPreferences.arrowHeight : 0),
      contentContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: layoutPreferences.arrowWidth + layoutPreferences.arrowHeight),
      contentContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: layoutPreferences.arrowWidth + layoutPreferences.arrowHeight),
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

  /// Clears constraints if needed.
  private func clearConstraints() {
    NSLayoutConstraint.deactivate(activeConstraints)
    activeConstraints = []
  }
}

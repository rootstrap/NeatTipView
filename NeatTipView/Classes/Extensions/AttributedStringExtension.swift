//
//  AttributedStringExtension.swift
//  NeatTipView
//
//  Created by Germán Stábile on 7/24/19.
//

import Foundation

extension NSAttributedString {
  func size(with size: CGSize) -> CGSize {
    let framesetter = CTFramesetterCreateWithAttributedString(self)
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                        CFRange(location: 0,length: 0),
                                                        nil,
                                                        size,
                                                        nil)
  }
}

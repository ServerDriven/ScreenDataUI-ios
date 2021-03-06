//
//  SDFont.swift
//  
//
//  Created by Leif on 2/23/21.
//

import SwiftUI

import ScreenData

public struct SDFont {
    public static var largeTitleFont: Font?
    public static var titleFont: Font?
    public static var headlingFont: Font?
    public static var bodyFont: Font?
    public static var footnoteFont: Font?
    public static var captionFont: Font?
    
    public static func font(for fontType: FontType) -> Font {
        switch fontType {
        case .largeTitle:
            return largeTitleFont ?? .largeTitle
        case .title:
            return titleFont ?? .title
        case .headline:
            return headlingFont ?? .headline
        case .body:
            return bodyFont ?? .body
        case .footnote:
            return footnoteFont ?? .footnote
        case .caption:
            return captionFont ?? .caption
        }
    }
    
}

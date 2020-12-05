//
//  SDStyleModifier.swift
//  ScreenData
//
//  Created by Zach Eriksen on 11/13/20.
//

import SwiftUI
import ScreenData

public struct SDStyleModifier: ViewModifier {
    public var style: SomeStyle
    
    public func body(content: Content) -> some View {
        if style.isHidden {
            return AnyView(content.hidden())
        } else {
            return AnyView(
                content
                    .background(
                        style.backgroundColor.map {
                            AnyView(SDColor(color: $0))
                        } ?? AnyView(Color.clear)
                    )
                    .cornerRadius(CGFloat(style.cornerRadius))
            )
        }
        
    }
}

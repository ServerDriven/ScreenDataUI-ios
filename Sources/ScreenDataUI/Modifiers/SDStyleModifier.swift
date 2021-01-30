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
    
    private var width: CGFloat? {
        guard let width = style.width else {
            return nil
        }
        
        return CGFloat(width)
    }
    
    private var height: CGFloat? {
        guard let height = style.height else {
            return nil
        }
        
        return CGFloat(height)
    }
    
    public func body(content: Content) -> some View {
        if style.isHidden {
            return AnyView(
                content
                    .hidden()
                    .frame(width: 0, height: 0, alignment: .center)
            )
        } else {
            return AnyView(
                content
                    .padding(CGFloat(style.padding))
                    .background(
                        style.backgroundColor.map {
                            AnyView(SDColor(color: $0))
                        } ?? AnyView(Color.clear)
                    )
                    .cornerRadius(CGFloat(style.cornerRadius))
                    .foregroundColor(style.foregroundColor.map {
                        SDColor(color: $0).body as? Color
                    } ?? Color.primary)
                    .frame(
                        width: width,
                        height: height,
                        alignment: .center
                    )
            )
        }
        
    }
}

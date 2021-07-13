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
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        if style.isHidden {
            content
                .hidden()
                .frame(width: 0, height: 0, alignment: .center)
        } else if style.padding != 0 {
            content
                .padding(CGFloat(style.padding))
                .background(
                    style.backgroundColor.map {
                        SDColor(color: $0)
                    } ?? SDColor(color: SomeColor(red: 0, green: 0, blue: 0, alpha: 0))
                )
                .cornerRadius(CGFloat(style.cornerRadius))
                .foregroundColor(
                    style.foregroundColor.map {
                        SDColor(color: $0).body as? Color
                    } ?? Color.primary
                )
                .frame(
                    width: width,
                    height: height,
                    alignment: .center
                )
        } else {
            content
                .background(
                    style.backgroundColor.map {
                        SDColor(color: $0)
                    } ?? SDColor(color: SomeColor(red: 0, green: 0, blue: 0, alpha: 0))
                )
                .cornerRadius(CGFloat(style.cornerRadius))
                .foregroundColor(
                    style.foregroundColor.map {
                        SDColor(color: $0).body as? Color
                    } ?? Color.primary
                )
                .frame(
                    width: width,
                    height: height,
                    alignment: .center
                )
        }
    }
}

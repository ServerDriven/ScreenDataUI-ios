//
//  SDColor.swift
//  ScreenDataUI
//
//  Created by Zach Eriksen on 11/13/20.
//

import SwiftUI
import ScreenData

public struct SDColor: View {
    public var color: SomeColor
    
    public init(color: SomeColor) {
        self.color = color
    }
    
    public var body: some View {
        Color(
            UIColor(red: CGFloat(color.red) / 255.0,
                    green: CGFloat(color.green) / 255.0,
                    blue: CGFloat(color.blue) / 255.0,
                    alpha: CGFloat(color.alpha) / 255.0)
        )
    }
}

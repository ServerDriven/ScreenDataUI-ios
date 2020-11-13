//
//  SDColor.swift
//  ScreenDataUI
//
//  Created by Zach Eriksen on 11/13/20.
//

import SwiftUI
import ScreenData

public struct SDColor: SwiftUI.View {
    public var color: ScreenData.Color
    
    public init(color: ScreenData.Color) {
        self.color = color
    }
    
    public var body: some SwiftUI.View {
        SwiftUI.Color(
            UIColor(red: CGFloat(color.red) / 255.0,
                    green: CGFloat(color.green) / 255.0,
                    blue: CGFloat(color.blue) / 255.0,
                    alpha: CGFloat(color.alpha) / 255.0)
        )
    }
}

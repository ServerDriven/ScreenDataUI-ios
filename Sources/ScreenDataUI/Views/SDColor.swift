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
            UIColor(
                red: CGFloat(color.red),
                green: CGFloat(color.green),
                blue: CGFloat(color.blue),
                alpha: CGFloat(color.alpha)
            )
        )
    }
}

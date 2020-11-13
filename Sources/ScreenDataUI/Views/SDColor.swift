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
            UIColor(red: CGFloat(color.red),
                    green: CGFloat(color.green),
                    blue: CGFloat(color.blue),
                    alpha: CGFloat(color.alpha))
        )
    }
}

struct SDColor_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        SDColor(color: ScreenData.Color(red: 50, green: 100, blue: 255))
    }
}

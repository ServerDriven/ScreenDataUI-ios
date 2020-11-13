//
//  SDLabel.swift
//  ScreenData
//
//  Created by Zach Eriksen on 11/13/20.
//

import SwiftUI
import ScreenData

public struct SDLabel: SwiftUI.View {
    public var label: ScreenData.Label
    
    public init(label: ScreenData.Label) {
        self.label = label
    }
    
    public var body: some SwiftUI.View {
        VStack {
            // Title
            SwiftUI.Text(label.title)
                .font(.title)

            // Subtitle
            label.subtitle.map {
                SwiftUI.Text($0)
                    .font(.headline)
            }
        }
        .background(with:
            label.style ?? ScreenData.Style()
        )
    }
}

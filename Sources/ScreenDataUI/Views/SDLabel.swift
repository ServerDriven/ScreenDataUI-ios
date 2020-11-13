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

struct SDLabel_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        SDLabel(label: .init(title: "Some Title", subtitle: "Subtitle...", style: .init(backgroundColor: .init(red: 255, green: 255, blue: 0, alpha: 255), isHidden: false), destination: Destination(type: .screen, screen: ScreenDestination(screenID: "3"), url: nil, deepLink: nil)))
    }
}

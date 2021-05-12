//
//  SDLabel.swift
//  ScreenData
//
//  Created by Zach Eriksen on 11/13/20.
//

import SwiftUI
import ScreenData
import ScreenDataNavigation

public struct SDLabel: View {
    public var label: SomeLabel
    
    public init(
        label: SomeLabel
    ) {
        self.label = label
    }
    
    public var body: some View {
        SDDestinationLink(provider: SDScreenProvider(), destination: label.destination) {
            VStack {
                // Title
                Text(label.title)
                    .font(SDFont.font(for: label.font))
                    .multilineTextAlignment(.leading)
                
                
                // Subtitle
                label.subtitle.map {
                    Text($0)
                        .font(SDFont.font(for: .headline))
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(
                minWidth: 44,
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(with: label.style)
        }
    }
}

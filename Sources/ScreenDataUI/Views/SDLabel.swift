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
    public var provider: ScreenProviding
    public var label: SomeLabel
    
    public init(
        provider: ScreenProviding = MockScreenProvider(mockScreen: SomeScreen(title: "Some Title", subtitle: "Some Sub Title", backgroundColor: SomeColor(red: 255, green: 255, blue: 255), someView: SomeLabel(title: "Hello, World!").someView)),
        label: SomeLabel
    ) {
        self.provider = provider
        self.label = label
    }
    
    public var body: some View {
        SDDestinationLink(provider: provider, destination: label.destination) {
            VStack {
                // Title
                Text(label.title)
                    .font(.title)
                    .alignmentGuide(.leading) { d in d[.leading] }
                
                // Subtitle
                label.subtitle.map {
                    Text($0)
                        .font(.headline)
                        .alignmentGuide(.leading) { d in d[.leading] }
                }
            }
            .background(with: label.style)
        }
    }
}

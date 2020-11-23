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
    
    public init(label: SomeLabel) {
        self.label = label
    }
    
    public var body: some View {
        SDDestinationLink(provider: MockScreenProvider(mockScreen: SomeScreen(title: "Some Title", subtitle: "Some Sub Title", backgroundColor: SomeColor(red: 255, green: 255, blue: 255), someView: SomeLabel(title: "Hello, World!").someView)), destination: label.destination) {
            VStack {
                // Title
                Text(label.title)
                    .font(.title)
                
                // Subtitle
                label.subtitle.map {
                    Text($0)
                        .font(.headline)
                }
            }
            .background(with: label.style)
        }
    }
}

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
        provider: ScreenProviding = MockScreenProvider(mockScreen: SomeScreen(title: "Some Title", subtitle: "Some Sub Title", backgroundColor: SomeColor(red: 1, green: 1, blue: 1), someView: SomeLabel(title: "Hello, World!").someView)),
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
                    .multilineTextAlignment(label.destination.map { _ in .leading } ?? .center)
                
                // Subtitle
                label.subtitle.map {
                    Text($0)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(minWidth: 44,
                   maxWidth: .infinity,
                   alignment: label.destination.map { _ in .center } ?? .leading)
            .background(with: label.style)
        }
    }
}

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
    
    private var font: Font {
        switch label.font {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .headline:
            return .headline
        case .body:
            return .body
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        }
    }
    
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
                    .font(font)
                    .multilineTextAlignment(label.destination.map { _ in .center } ?? .leading)
                
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

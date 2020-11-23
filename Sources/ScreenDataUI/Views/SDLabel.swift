//
//  SDLabel.swift
//  ScreenData
//
//  Created by Zach Eriksen on 11/13/20.
//

import SwiftUI
import ScreenData

public struct SDLabel: View {
    public var label: SomeLabel
    
    public init(label: SomeLabel) {
        self.label = label
    }
    
    public var body: some View {
        mainView
    }
    
    private var mainView: some View {
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

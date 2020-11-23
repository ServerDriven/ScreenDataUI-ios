//
//  SDLabeledImage.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDLabeledImage: View {
    public let labeledImage: SomeLabeledImage
    
    public init(labeledImage: SomeLabeledImage) {
        self.labeledImage = labeledImage
    }
    
    public var body: some View {
        VStack {
            SDImage(image: labeledImage.someImage)
            SDLabel(label: SomeLabel(title: labeledImage.title, subtitle: labeledImage.subtitle))
        }
        .background(with: labeledImage.style)
    }
}

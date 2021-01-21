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
        SDDestinationLink(provider: SDScreenProvider(), destination: labeledImage.destination) {
            VStack {
                SDImage(image: labeledImage.someImage)
                SDLabel(label: SomeLabel(title: labeledImage.title, style: labeledImage.style))
                if let subtitle = labeledImage.subtitle {
                    SDText(text: SomeText(title: subtitle, style: labeledImage.style))
                }
            }
            .background(with: labeledImage.style)
        }
    }
}

//
//  SDImage.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDImage: View {
    public static var defaultForegroundColor: Color?
    
    public var image: SomeImage
    private var progressTint: Color
    
    public init(image: SomeImage) {
        self.image = image
        
        if let style = image.style,
           let foregroundColor = style.foregroundColor,
           let tint = SDColor(color: foregroundColor).body as? Color {
            self.progressTint = tint
        } else if let defaultTint = SDImage.defaultForegroundColor {
            self.progressTint = defaultTint
        } else {
            self.progressTint = .primary
        }
    }
    
    public var body: some View {
        SDDestinationLink(provider: SDScreenProvider(), destination: image.destination) {
            AsyncImage(url: URL(string: image.url)!) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
            }
            .aspectRatio(contentMode: .fit)
            .background(with: image.style)
        }
    }
}

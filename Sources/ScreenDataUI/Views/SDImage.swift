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
    
    public init(image: SomeImage) {
        self.image = image
    }
    
    public var body: some View {
        SDDestinationLink(provider: SDScreenProvider(), destination: image.destination) {
            AsyncImage(url: URL(string: image.url)!) {
                ProgressView()
                    .foregroundColor(image.style?.foregroundColor.map {
                        SDColor(color: $0).body as? Color
                    } ?? SDImage.defaultForegroundColor ?? .primary)
            }
            .aspectRatio(contentMode: .fit)
            .background(with: image.style)
        }
    }
}

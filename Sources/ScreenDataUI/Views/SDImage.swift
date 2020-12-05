//
//  SDImage.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDImage: View {
    public var image: SomeImage
    
    public init(image: SomeImage) {
        self.image = image
    }
    
    public var body: some View {
        AsyncImage(url: URL(string: image.url)!) {
            Text("Loading...")
        }
        .aspectRatio(contentMode: .fit)
        .background(with: image.style)
    }
}

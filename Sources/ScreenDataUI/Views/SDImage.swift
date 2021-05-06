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
    
    private var width: CGFloat? {
        guard let width = image.style?.width else {
            return nil
        }
        
        return CGFloat(width)
    }
    
    private var height: CGFloat? {
        guard let height = image.style?.height else {
            return nil
        }
        
        return CGFloat(height)
    }
    
    private var imageView: some View {
        if let assetName = image.assetName,
           let image = UIImage(named: assetName) {
            return AnyView(Image(uiImage: image))
        } else {
            return AnyView(AsyncImage(
                url: URL(string: image.url)!,
                width: width,
                height: height,
                contentMode: image.aspectScale == ImageAspectScale.fit ? .fit : .fill
            ) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
                    .padding()
            })
        }
    }
    
    
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
            imageView
        }
    }
}

//
//  SDImage.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData
import Combine

public class SDImageStore: ObservableObject {
    @Published public var image: UIImage?
    
    private var task: AnyCancellable?
    
    deinit {
        task?.cancel()
    }
    
    public func load(
        imageWithURL urlString: String,
        provider: SDImageProviding,
        storer: SDImageStoring?
    ) {
        var imageLoading: AnyPublisher<UIImage?, Error>
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        defer {
            task = imageLoading
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] image in
                        self?.image = image
                    }
                )
        }
        
        guard let storer = storer else {
            
            imageLoading = provider.image(forURL: url)
            return
        }
        
        imageLoading = provider.image(forURL: url)
            .flatMap { image in
                storer.store(image: image, forURL: url)
                    .map {
                        image
                    }
            }
            .eraseToAnyPublisher()
    }
}

public struct SDImage: View {
    public static var defaultForegroundColor: Color?
    public static var defaultImageProvider: SDImageProviding = SDImageURLProvider()
    public static var defaultImageStorer: SDImageStoring? = nil
    
    @StateObject private var store = SDImageStore()
    
    public var image: SomeImage
    private var progressTint: Color
    
    private var width: CGFloat {
        guard let width = image.style?.width else {
            return .infinity
        }
        
        if CGFloat(width) >= UIScreen.main.bounds.width {
            return .infinity
        }
        
        return CGFloat(width)
    }
    
    private var height: CGFloat {
        guard let height = image.style?.height else {
            return .infinity
        }
        
        return CGFloat(height)
    }
    
    private var imageView: some View {
        Group {
            if let placeholderAssetName = image.assetName,
               let placeholder = UIImage(named: placeholderAssetName) {
                Image(uiImage: placeholder)
            } else if let loadedImage = store.image {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: image.aspectScale == ImageAspectScale.fit ? .fit : .fill)
                    .frame(
                        minWidth: 0, maxWidth: width,
                        minHeight: 0, maxHeight: height,
                        alignment: .center
                    )
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
                    .padding()
                    .onAppear {
                        if store.image == nil {
                            store.load(
                                imageWithURL: image.url,
                                provider: SDImage.defaultImageProvider,
                                storer: SDImage.defaultImageStorer
                            )
                        }
                    }
            }
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

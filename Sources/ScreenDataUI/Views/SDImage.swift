//
//  SDImage.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

import Combine
import Task

public protocol SDImageProviding {
    func image(forURL url: String) -> AnyPublisher<UIImage?, Error>
}

public struct SDImageURLProvider: SDImageProviding {
    public func image(forURL url: String) -> AnyPublisher<UIImage?, Error> {
        Task.fetch(url: URL(string: url)!)
            .flatMap { (data, response) in
                Task.do {
                    guard let data = data else {
                        return nil
                    }
                    return UIImage(data: data)
                }
            }
            .eraseToAnyPublisher()
    }
}

public protocol SDImageStoring {
    func store(image: UIImage) -> AnyPublisher<Void, Error>
}

public class SDImageStore: ObservableObject {
    @Published public var image: UIImage?
    
    private var task: AnyCancellable?
    
    deinit {
        task?.cancel()
    }
    
    public func load(
        imageWithURL url: String?,
        provider: SDImageProviding
    ) {
        guard let url = url else {
            return
        }
        
        task = provider.image(forURL: url)
            .receive(on: DispatchQueue.main)
            .sink(
                .success { [weak self] image in
                    self?.image = image
                }
            )
    }
}

public struct SDImage: View {
    public static var defaultForegroundColor: Color?
    public static var defaultImageProvider: SDImageProviding = SDImageURLProvider()
    public static var defaultImageStorer: SDImageStoring!
    
    @StateObject private var store = SDImageStore()
    
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
        Group {
            if let loadedImage = store.image {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: image.aspectScale == ImageAspectScale.fit ? .fit : .fill)
                    .frame(width: width ?? UIScreen.main.bounds.width, height: height, alignment: .center)
            } else if let placeholderAssetName = image.assetName,
                      let placeholder = UIImage(named: placeholderAssetName) {
                Image(uiImage: placeholder)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
                    .padding()
            }
        }
        .onAppear {
            if store.image == nil {
                store.load(imageWithURL: image.url, provider: SDImage.defaultImageProvider)
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

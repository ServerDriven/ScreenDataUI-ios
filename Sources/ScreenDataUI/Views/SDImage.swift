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
    func image(forURL url: URL) -> AnyPublisher<UIImage?, Error>
}

public struct SDImageURLProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        Task.fetch(url: url)
            .flatMap { (data, response) in
                Task.do {
                    guard let data = data else {
                        return nil
                    }
                    let image = UIImage(data: data)
                    
                    return image
                }
            }
            .eraseToAnyPublisher()
    }
}

public struct SDImageUserDefaultsProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        Task.do {
            let imageData: Data? = UserDefaults.standard.data(forKey: url.absoluteString)
            
            guard let data = imageData else {
                return nil
            }
            let image = UIImage(data: data)
            
            return image
            
        }
        .eraseToAnyPublisher()
    }
}

public struct SDImageURLUserDefaultsProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        SDImageUserDefaultsProvider()
            .image(forURL: url)
            .flatMap { image -> AnyPublisher<UIImage?, Error> in
                guard let image = image else {
                    return Task.fetch(url: url)
                        .flatMap { (data, response) in
                            Task.do {
                                guard let data = data else {
                                    return nil
                                }
                                let image = UIImage(data: data)
                                
                                return image
                            }
                        }
                        .eraseToAnyPublisher()
                }
                
                return Just(image)
                    .mapError { (Never) -> Error in }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}

public protocol SDImageStoring {
    func store(image: UIImage?, forURL url: URL) -> AnyPublisher<Void, Error>
}

public struct SDImageUserDefaultsStorer: SDImageStoring {
    public init() { }
    
    public func store(image: UIImage?, forURL url: URL) -> AnyPublisher<Void, Error> {
        Task.do {
            if let imageData = image?.pngData() {
                UserDefaults.standard.set(imageData, forKey: url.absoluteString)
            } else {
                UserDefaults.standard.set(nil, forKey: url.absoluteString)
            }
        }
        .eraseToAnyPublisher()
    }
}

public class SDImageStore: ObservableObject {
    @Published public var image: UIImage?
    
    private var task: AnyCancellable?
    
    deinit {
        task?.cancel()
    }
    
    public func load(
        imageWithURL urlString: String,
        provider: SDImageProviding,
        storer: SDImageStoring
    ) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        task = provider.image(forURL: url)
            .flatMap { image in
                storer.store(image: image, forURL: url)
                    .map {
                        image
                    }
            }
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
    public static var defaultImageStorer: SDImageStoring = SDImageUserDefaultsStorer()
    
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
            if let placeholderAssetName = image.assetName,
               let placeholder = UIImage(named: placeholderAssetName) {
                Image(uiImage: placeholder)
            } else if let loadedImage = store.image {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: image.aspectScale == ImageAspectScale.fit ? .fit : .fill)
                    .frame(width: width ?? UIScreen.main.bounds.width, height: height, alignment: .center)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
                    .padding()
                    .onAppear {
                        if store.image == nil {
                            store.load(imageWithURL: image.url, provider: SDImage.defaultImageProvider, storer: SDImageUserDefaultsStorer())
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

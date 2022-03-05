//
//  SDImageProviding.swift
//  
//
//  Created by Leif on 5/19/21.
//

import Foundation
import SwiftUI
import Combine

public protocol SDImageProviding {
    func image(forURL url: URL) -> AnyPublisher<UIImage?, Error>
}

public struct SDImageProvidingFailure: Error {
    public let description: String
}

public struct SDImageURLProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        Future { promise in
            URLSession.shared
                .dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    
                    guard let data = data else {
                        log(level: .error("(SDImageURLProvider) Could not load Image for URL (\(url)). Response: \(String(describing: response)).", nil))
                        promise(.success(nil))
                        return
                    }
                    
                    promise(.success(UIImage(data: data)))
                }
                .resume()
        }
        .eraseToAnyPublisher()
    }
}

public struct SDImageFileProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        Future { promise in
            let key = url.absoluteString.replacingOccurrences(of: "/", with: "-")
            let path = FileManager.default.urls(
                for: .documentDirectory,
                   in: .userDomainMask
            )[0].appendingPathComponent(key)
            
            guard let data = try? Data(contentsOf: path) else {
                log(level: .error("(SDImageUserDefaultsProvider) Could not load Image for URL (\(url)).", nil))
                promise(.success(nil))
                return
            }
            
            promise(.success(UIImage(data: data)))
        }
        .eraseToAnyPublisher()
    }
}

public struct SDImageURLFileProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        SDImageFileProvider()
            .image(forURL: url)
            .flatMap { image -> AnyPublisher<UIImage?, Error> in
                guard let image = image else {
                    return SDImageURLProvider().image(forURL: url)
                }
                
                return Just(image)
                    .mapError { (Never) -> Error in }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}

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
                        let error = SDImageProvidingFailure(description: "Could not load Image for URL (\(url)). Response: \(String(describing: response))")
                        promise(.failure(error))
                        return
                    }
                    
                    promise(.success(UIImage(data: data)))
                }
                .resume()
        }
        .eraseToAnyPublisher()
    }
}

public struct SDImageUserDefaultsProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        Future { promise in
            let imageData: Data? = UserDefaults.standard.data(
                forKey: url.absoluteString
            )
            
            guard let data = imageData else {
                let error = SDImageProvidingFailure(description: "Could not load Image for URL (\(url)).")
                promise(.failure(error))
                return
            }
            
            promise(.success(UIImage(data: data)))
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
                    return SDImageURLProvider().image(forURL: url)
                }
                
                return Just(image)
                    .mapError { (Never) -> Error in }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}

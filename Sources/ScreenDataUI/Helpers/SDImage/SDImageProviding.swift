//
//  SDImageProviding.swift
//  
//
//  Created by Leif on 5/19/21.
//

import Foundation
import SwiftUI
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
                    return SDImageURLProvider().image(forURL: url)
                }
                
                return Just(image)
                    .mapError { (Never) -> Error in }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}

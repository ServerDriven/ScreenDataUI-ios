//
//  SDImageProviding.swift
//  
//
//  Created by Leif on 5/19/21.
//

import FLet
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
            __.transput.url.in(
                url: url,
                successHandler: { (data: Data, response) in
                    promise(.success(UIImage(data: data)))
                },
                errorHandler: { promise(.failure($0)) },
                failureHandler: { response in
                    log(level: .error("(SDImageURLProvider) Could not load Image for URL (\(url)). Response: \(String(describing: response)).", nil))
                    promise(.success(nil))
                }
            )
        }
        .eraseToAnyPublisher()
    }
}

public struct SDImageFileProvider: SDImageProviding {
    public init() { }
    
    public func image(forURL url: URL) -> AnyPublisher<UIImage?, Error> {
        Future { promise in
            let key = url.absoluteString.replacingOccurrences(of: "/", with: "-")
            
            guard let data = try? __.transput.file.data(filename: key) else {
                log(level: .error("(SDImageFileProvider) Could not load Image for key (\(key)).", nil))
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

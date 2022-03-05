//
//  SDImageStoring.swift
//  
//
//  Created by Leif on 5/19/21.
//

import Foundation
import SwiftUI
import Combine

public protocol SDImageStoring {
    func store(image: UIImage?, forURL url: URL) -> AnyPublisher<Void, Error>
}

public struct SDImageFileStore: SDImageStoring {
    public init() { }
    
    public func store(image: UIImage?, forURL url: URL) -> AnyPublisher<Void, Error> {
        Future { promise in
            let key = url.absoluteString.replacingOccurrences(of: "/", with: "-")
            let path = FileManager.default.urls(
                for: .documentDirectory,
                   in: .userDomainMask
            )[0].appendingPathComponent(key)
            
            if let imageData = image?.pngData() {
                try? imageData.write(to: path)
            }
            
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}

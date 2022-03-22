//
//  SDImageStoring.swift
//  
//
//  Created by Leif on 5/19/21.
//

import Combine
import FLet
import Foundation
import SwiftUI

public protocol SDImageStoring {
    func store(image: UIImage?, forURL url: URL) -> AnyPublisher<Void, Error>
}

public struct SDImageFileStore: SDImageStoring {
    public init() { }
    
    public func store(image: UIImage?, forURL url: URL) -> AnyPublisher<Void, Error> {
        Future { promise in
            let key = url.absoluteString.replacingOccurrences(of: "/", with: "-")
            
            if let imageData = image?.pngData() {
                try? __.transput.file.out(imageData, filename: key)
            }
            
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}

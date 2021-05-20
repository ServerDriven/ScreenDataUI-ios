//
//  SDImageStoring.swift
//  
//
//  Created by Leif on 5/19/21.
//

import Foundation
import SwiftUI
import Combine
import Task

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

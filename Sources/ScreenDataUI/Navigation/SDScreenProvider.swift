//
//  SDScreenProvider.swift
//  
//
//  Created by Zach Eriksen on 1/7/21.
//

import Foundation
import ScreenData
import ScreenDataNavigation
import Combine

public struct SDScreenProvider: ScreenProviding {
    public static var `default`: ScreenProviding?
    
    public init() { }
    
    public func screen(forID id: String) -> AnyPublisher<SomeScreen, Error> {
        guard let provider = SDScreenProvider.default else {
            return FileScreenProvider(baseKey: "SDScreenStore")
                .screen(forID: id)
                .eraseToAnyPublisher()
        }
        
        return provider.screen(forID: id)
    }
}

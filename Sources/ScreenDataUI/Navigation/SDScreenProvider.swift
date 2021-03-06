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
            return ScreenDataNavigation.MockScreenProvider(
                mockScreen: SomeScreen(
                    title: "Mock Screen",
                    backgroundColor: SomeColor(red: 1, green: 1, blue: 1),
                    someView: SomeText(title: "Set SDScreenProvider.default").someView
                )
            )
            .screen(forID: id)
            .eraseToAnyPublisher()
        }
        
        return provider.screen(forID: id)
    }
}

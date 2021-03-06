//
//  SDScreenStore.swift
//  
//
//  Created by Zach Eriksen on 1/12/21.
//

import Foundation
import ScreenData
import ScreenDataNavigation
import Combine

public struct SDScreenStore: ScreenStoring {
    public static var `default`: ScreenStoring?
    
    public init() { }
    
    public func store(screens: [SomeScreen]) -> AnyPublisher<Void, Error> {
        guard let store = SDScreenStore.default else {
            print("[\(Data())] \(#function) SAVED Screens: \(screens.map(\.id))")
            return ScreenDataNavigation.UserDefaultScreenStorer(baseKey: "SDScreenStore")
                .store(screens: screens)
        }
        
        return store.store(screens: screens)
    }
}

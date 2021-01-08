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

struct SDScreenProvider: ScreenProviding {
    static var `default`: ScreenProviding?
    
    func screen(forID id: String) -> Future<SomeScreen, Error> {
        guard let provider = SDScreenProvider.default else {
            return ScreenDataNavigation.MockScreenProvider(mockScreen:
                                                            SomeScreen(title: "404",
                                                                       subtitle: nil,
                                                                       backgroundColor: SomeColor(red: 1, green: 1, blue: 1),
                                                                       someView: SomeText(title: "Set SDScreenProvider.default").someView)
            ).screen(forID: id)
        }
        
        return provider.screen(forID: id)
    }
}

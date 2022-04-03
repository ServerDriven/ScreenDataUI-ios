//
//  SDScreen.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData
import Combine

public struct SDScreen: View, Equatable {
    public static var isDebugging: Bool = false
    
    public var screen: SomeScreen
    
    public init(screen: SomeScreen) {
        self.screen = screen
        
        DispatchQueue.global().async {
            let sema = DispatchSemaphore(value: 0)
            
            let task = screen.load(withProvider: SDScreenProvider())
                .map { screens in
                    SDScreenStore()
                        .store(screens: screens + [screen])
                }
                .eraseToAnyPublisher()
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            log(level: .error("SDScreen.init -> SDScreenStore.store", error))
                        }
                        sema.signal()
                    },
                    receiveValue: { _ in }
                )
            
            sema.wait()
            
            task.cancel()
        }
    }
    
    public var body: some View {
        VStack {
            if let headerView = screen.headerView {
                headerView.ui
            }
            
            screen.someView.ui
            
            if let footerView = screen.footerView {
                footerView.ui
            }
        }
        .background(
            Color(
                red: Double(screen.backgroundColor.red),
                green: Double(screen.backgroundColor.green),
                blue: Double(screen.backgroundColor.blue),
                opacity: Double(screen.backgroundColor.alpha)
            )
        )
        .navigationBarTitle(screen.title)
    }
}

//
//  SDScreen.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData
import Combine

public struct SDScreen: View {
    public let id = UUID()
    public var screen: SomeScreen
    
    public init(screen: SomeScreen) {
        self.screen = screen
        
        DispatchQueue.global().async {
            let lock = NSLock()
            
            let task = SDScreenStore.default?.store(screens: [screen]).sink(receiveCompletion: { _ in }, receiveValue: { _ in
                print("SAVED Screen")
                lock.unlock()
            })
            
            lock.lock()
            
            task?.cancel()
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
        .background(Color(red: Double(screen.backgroundColor.red),
                           green: Double(screen.backgroundColor.green),
                           blue: Double(screen.backgroundColor.blue),
                           opacity: Double(screen.backgroundColor.alpha)))
        .navigationBarTitle(screen.title)
    }
}

extension SDScreen: Identifiable { }

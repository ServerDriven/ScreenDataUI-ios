//
//  SDScreen.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDScreen: View {
    public var screen: SomeScreen
    
    public init(screen: SomeScreen) {
        self.screen = screen
    }
    
    public var body: some View {
        VStack {
            SDLabel(label: SomeLabel(title: screen.title, subtitle: screen.subtitle))
            
            if let headerView = screen.headerView {
                headerView.ui
            }
            
            screen.someView.ui
            
            if let footerView = screen.footerView {
                footerView.ui
            }
        }
    }
}

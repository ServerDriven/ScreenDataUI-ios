//
//  SDButton.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDButton: View {
    public var button: SomeButton
    
    public init(button: SomeButton) {
        self.button = button
    }
    
    public var body: some View {
        Button(action: {
            print("[SDButton] ActionID: \(String(describing: button.actionID)) & Destination: \(String(describing: button.destination))")
        }) {
            Text(button.title)
        }
        .background(with: button.style)
    }
}

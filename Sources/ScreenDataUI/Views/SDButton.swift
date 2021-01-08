//
//  SDButton.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData
import ScreenDataNavigation

public typealias SDAction = () -> Void

public struct SDButton: View {
    public static var actions: [String: SDAction] = [:]
    public static func add(
        actionWithID actionID: String,
        action: @escaping SDAction
    ) {
        actions[actionID] = action
    }
    
    @StateObject private var store: SDDestinationStore = SDDestinationStore()
    @State private var modalScreen: SDScreen?
    
    public var button: SomeButton
    
    public init(button: SomeButton) {
        self.button = button
    }
    
    public var body: some View {
        Button(action: {
            print("[SDButton] ActionID: \(String(describing: button.actionID)) & Destination: \(String(describing: button.destination))")
            if let actionID = button.actionID,
               let action = SDButton.actions[actionID] {
                action()
            }
            
            if button.destination != nil {
                print("TODO: Navigate to destination")
                modalScreen = store.destinationView
            }
        }) {
            Text(button.title)
        }
        .sheet(item: $modalScreen) { (destination) in
            destination
        }
        .onAppear {
            store.load(destination: button.destination, provider: SDScreenProvider())
        }
    }
}

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
        guard button.destination != nil else {
            return AnyView(
                Button(
                    action: buttonAction,
                    label: {
                        Text(button.title)
                            .font(SDFont.font(for: .body))
                            .background(with: button.style)
                    }
                )
            )
        }
        
        return AnyView(
            SDDestinationLink(
                provider: SDScreenProvider(),
                destination: button.destination,
                action: buttonAction,
                content: {
                    Text(button.title)
                        .font(SDFont.font(for: .body))
                        .background(with: button.style)
                }
            )
        )
    }
    
    private func buttonAction() {
        print("[SDButton] ActionID: \(String(describing: button.actionID)) & Destination: \(String(describing: button.destination))")
        if let actionID = button.actionID,
           let action = SDButton.actions[actionID] {
            action()
        }
        
        if let destination = button.destination {
            print("Navigate to destination: (\(destination))")
            modalScreen = store.destinationView
        }
        
    }
}

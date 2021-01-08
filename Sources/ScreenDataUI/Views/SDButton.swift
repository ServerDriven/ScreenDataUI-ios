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
    
    public var button: SomeButton
    
    public init(button: SomeButton) {
        self.button = button
    }
    
    public var body: some View {
        SDDestinationLink(provider: SDScreenProvider.provider, destination: button.destination) {
            SDButton(button: button)
        }
    }
}

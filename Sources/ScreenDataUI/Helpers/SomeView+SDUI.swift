//
//  SomeView+SDUI.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public extension SomeView {
    var ui: some View {
        switch type {
        case .button:
            return AnyView(SDButton(button: someButton!))
        case .label:
            return AnyView(SDLabel(label: someLabel!))
        case .text:
            return AnyView(SDText(text: someText!))
        case .labeledImage:
            return AnyView(SDLabeledImage(labeledImage: someLabeledImage!))
        case .container:
            return AnyView(SDContainerView(container: container!))
        case .image:
            return AnyView(SDImage(image: someImage!))
        case .custom:
            return AnyView(Text("404")) // TODO: Handle Custom Views
        }
    }
}

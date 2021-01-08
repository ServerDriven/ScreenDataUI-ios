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
            return AnyView(SDContainerView(container: someContainer!))
        case .image:
            return AnyView(SDImage(image: someImage!))
        case .spacer:
            guard let size = someSpacer?.size else {
                return AnyView(Spacer())
            }
            
            return AnyView(Spacer().frame(width: CGFloat(size),
                                          height: CGFloat(size),
                                          alignment: .center))
        case .custom:
            return AnyView(SDCustomView(custom: someCustomView!))
        }
    }
}

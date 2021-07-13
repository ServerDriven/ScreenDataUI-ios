//
//  SomeView+SDUI.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public extension SomeView {
    
    @ViewBuilder
    var ui: some View {
        if type == .button {
            SDButton(button: someButton!)
        } else if type == .label {
            SDLabel(label: someLabel!)
        } else if type == .text {
            SDText(text: someText!)
        } else if type == .container {
            SDContainerView(container: someContainer!)
        } else if type == .image {
            SDImage(image: someImage!)
        } else if type == .spacer {
            if let size = someSpacer?.size {
                Spacer().frame(width: CGFloat(size),
                               height: CGFloat(size),
                               alignment: .center)
            } else {
                Spacer()
            }
        } else if type == .custom {
            SDCustomView(custom: someCustomView!)
        } else {
            EmptyView()
        }
    }
}

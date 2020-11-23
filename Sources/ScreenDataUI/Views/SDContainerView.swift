//
//  SDContainerView.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDContainerView: View {
    public var container: SomeContainerView
    
    public init(container: SomeContainerView) {
        self.container = container
    }
    
    public var views: some View {
        ForEach(container.views, id: \.self) { view in
            view.ui
        }
    }
    
    public var body: some View {
        ScrollView {
            if container.axis == .vertical {
                VStack {
                    views
                }
            } else {
                HStack {
                    views
                }
            }
        }
    }
}

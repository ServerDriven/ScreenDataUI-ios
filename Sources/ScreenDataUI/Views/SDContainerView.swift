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
    
    private var scrollAxis: Axis.Set {
        switch container.axis {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }
    
    private var views: some View {
        ForEach(container.views, id: \.self) { view in
            view.ui
        }
    }
    
    private var scrollingView: some View {
        ScrollView(scrollAxis) {
            content
        }
//        .background(with: container.style)
    }
    
    private var content: some View {
        Group {
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
    
    public var body: some View {
        if container.isScrollable {
            scrollingView
        } else {
            content
//                .background(with: container.style)
        }
    }
}

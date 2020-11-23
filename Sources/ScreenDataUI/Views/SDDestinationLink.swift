//
//  SDDestinationLink.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import Combine
import ScreenData
import ScreenDataNavigation

public struct SDDestinationLink<Content>: View where Content: View {
    @State private var task: AnyCancellable?
    @State private var destinationView: SDScreen?
    public var provider: ScreenProviding
    
    public var destination: Destination?
    public var content: () -> Content
    
    public init(
        provider: ScreenProviding,
        destination: Destination?,
        content: @escaping () -> Content
    ) {
        self.provider = provider
        self.destination = destination
        self.content = content
    }
    
    public var body: some View {
        if destination == nil {
            return AnyView(content())
        }
        
        guard let destinationView = destinationView else {
            return AnyView(loadingView)
        }
        
        return AnyView(NavigationLink(
                        destination: destinationView,
                        label: {
                            content()
                        }))
        
    }
    
    public var loadingView: some View {
        guard let destination = destination else {
            return AnyView(content())
        }
        
        return AnyView(ProgressView()
                        .onAppear {
                            task = provider.screen(forID: destination.toID)
                                .receive(on: DispatchQueue.main)
                                .sink(receiveCompletion: { _ in },
                                      receiveValue: { (screen) in
                                        self.destinationView = SDScreen(screen: screen)
                                      })
                        })
    }
}

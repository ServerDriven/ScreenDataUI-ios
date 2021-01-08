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

public class SDDestinationStore: ObservableObject {
    @Published public var destinationView: SDScreen?
    
    private var task: AnyCancellable?
    
    public func load(destination: Destination?, provider: ScreenProviding) {
        guard destinationView == nil else {
            return
        }
        
        guard let destination = destination else {
            return
        }
        
        task = provider.screen(forID: destination.toID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { (screen) in
                    self.destinationView = SDScreen(screen: screen)
                  })
    }
}

public struct SDDestinationLink<Content>: View where Content: View {
    @StateObject private var store: SDDestinationStore = SDDestinationStore()
    
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
        
        guard let destinationView = store.destinationView else {
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
                            store.load(destination: destination,
                                       provider: provider)
                        })
    }
}

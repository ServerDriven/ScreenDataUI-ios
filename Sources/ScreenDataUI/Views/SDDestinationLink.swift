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
    
    deinit {
        task?.cancel()
    }
    
    public func load(destination: Destination?, provider: ScreenProviding) {
        guard let destination = destination else {
            return
        }
        
        task = provider.screen(forID: destination.toID)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] (screen) in
                    guard screen != self?.destinationView?.screen else {
                        return
                    }
                    self?.destinationView = SDScreen(screen: screen)
                }
            )
    }
}

public struct SDDestinationLink<Content>: View where Content: View {
    @Environment(\.openURL) private var openURL
    
    @StateObject private var store: SDDestinationStore = SDDestinationStore()
    @State private var isPresentingDestination = false
    
    public var provider: ScreenProviding
    
    public var destination: Destination?
    public var action: (() -> Void)?
    public var content: () -> Content
    
    public init(
        provider: ScreenProviding,
        destination: Destination?,
        action: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) {
        self.provider = provider
        self.destination = destination
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        if destination == nil {
            return AnyView(content())
        }
        
        guard destination?.type != .url else {
            return AnyView(
                Button(action: {
                    action?()
                    if let destinationURL = destination?.toID,
                       let url = URL(string: destinationURL) {
                        openURL(url)
                    }
                }, label: {
                    content()
                })
            )
        }
        
        guard let destinationView = store.destinationView else {
            return AnyView(loadingView)
        }
        
        return AnyView(
            NavigationLink(
                destination: destinationView,
                isActive: $isPresentingDestination,
                label: {
                    Button(action: {
                        action?()
                        isPresentingDestination = true
                    }, label: {
                        content()
                    })
                }
            )
            .onAppear {
                store.load(destination: destination, provider: provider)
            }
        )
    }
    
    public var loadingView: some View {
        guard let destination = destination else {
            return AnyView(content())
        }
        
        return AnyView(
            ProgressView()
                .onAppear {
                    store.load(destination: destination,
                               provider: provider)
                }
        )
    }
}

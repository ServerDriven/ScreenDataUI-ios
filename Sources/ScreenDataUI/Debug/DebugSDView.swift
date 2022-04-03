//
//  DebugSDView.swift
//  
//
//  Created by Leif on 4/2/22.
//

import ScreenData
import ScreenDataNavigation
import SwiftUI

public extension SomeView {
    var debug: some View { DebugSDView(view: self) }
}

struct DebugSDView: View {
    let view: SomeView
    
    var body: some View {
        ScrollView {
            debug(view: view)
        }
        .navigationTitle("Type: \(view.type.rawValue.capitalized)")
    }
    
    func preview(view: SomeView) -> some View {
        SDDestinationLink(
            provider: MockScreenProvider(
                mockScreen: SomeScreen(
                    title: "",
                    backgroundColor: SomeColor(red: 0, green: 0, blue: 0),
                    someView: view
                )
            ),
            destination: Destination(type: .screen, toID: ""),
            content: {
                Image(systemName: "doc.text.magnifyingglass")
            }
        )
    }
    
    func debug(view: SomeView, atDepth depth: Int = 0) -> AnyView {
        let tabDepth: (Int) -> String = { depth in String(repeating: "  ", count: depth) }
        
        if view.type == .button {
            return AnyView(
                HStack {
                    Text("◦\(tabDepth(depth))Button")
                    Spacer().frame(width: 8)
                    preview(view: view)
                    Spacer()
                }
            )
        } else if view.type == .label {
            return AnyView(
                HStack {
                    Text("◦\(tabDepth(depth))Label")
                    Spacer().frame(width: 8)
                    preview(view: view)
                    Spacer()
                }
            )
        } else if view.type == .text {
            return AnyView(
                HStack {
                    Text("◦\(tabDepth(depth))Text")
                    Spacer().frame(width: 8)
                    preview(view: view)
                    Spacer()
                }
            )
        } else if
            view.type == .container,
            let container = view.someContainer
        {
            return AnyView(
                VStack(alignment: .leading) {
                    HStack {
                        Text("◦\(tabDepth(depth))Container")
                        Spacer().frame(width: 8)
                        preview(view: view)
                        Spacer().frame(width: 8)
                        Text("[")
                        Spacer()
                    }
                    ForEach(container.views, id: \.self) { view in
                        debug(view: view, atDepth: depth + 1)
                    }
                    Text("◦\(tabDepth(depth))]")
                }
            )
        } else if view.type == .image {
            return AnyView(
                HStack {
                    Text("◦\(tabDepth(depth))Image")
                    Spacer().frame(width: 8)
                    preview(view: view)
                    Spacer()
                }
            )
        } else if view.type == .spacer {
            return AnyView(Text("◦\(tabDepth(depth))Spacer"))
        } else if
            view.type == .custom,
            let custom = view.someCustomView
        {
            return AnyView(
                VStack(alignment: .leading) {
                    Text("◦\(tabDepth(depth))Custom {")
                    
                    Text("◦\(tabDepth(depth + 1))ID: \"\(custom.id ?? "")\"")
                    
                    HStack {
                        Text("◦\(tabDepth(depth + 1))Preview:")
                        Spacer().frame(width: 8)
                        preview(view: view)
                        Spacer()
                    }
                    
                    if let views = custom.views {
                        Text("◦\(tabDepth(depth + 1))Views: [")
                        ForEach(views, id: \.self) { view in
                            debug(view: view, atDepth: depth + 2)
                        }
                        Text("◦\(tabDepth(depth + 1))]")
                    }
                    
                    Text("◦\(tabDepth(depth))}")
                }
            )
        } else {
            fatalError("Unknown View Type: \(view.type.rawValue)")
        }
    }
}

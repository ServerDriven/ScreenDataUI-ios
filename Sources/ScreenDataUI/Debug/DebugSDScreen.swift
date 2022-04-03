//
//  DebugSDScreen.swift
//  
//
//  Created by Leif on 4/2/22.
//

import ScreenData
import ScreenDataNavigation
import SwiftUI

public extension SDScreen {
    var debug: some View { DebugSDScreen(screen: screen) }
}

public struct DebugSDScreen: View {
    @State private var isDubugging: Bool = false
    
    public var screen: SomeScreen
    
    public init(screen: SomeScreen) {
        self.screen = screen
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                if isDubugging {
                    debugView
                } else {
                    SDScreen(screen: screen)
                }
                
                Button(
                    action: { isDubugging.toggle() },
                    label: {
                        Image(systemName: isDubugging ? "ant.circle.fill" : "ant.circle")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .background(
                                (isDubugging ? Color.green : Color.black)
                                    .cornerRadius(22)
                            )
                    }
                )
                .position(x: geo.size.width - 52, y: geo.size.height - 52)
            }
        }
    }
    
    public var debugView: some View {
        VStack {
            List {
                Section(
                    content: {
                        Text("ID: \(screen.id ?? "None")").font(.title)
                        Text("Title: \"\(screen.title)\"").font(.title)
                    },
                    header: { Text("Information") }
                )
                
                Section(
                    content: {
                        if let headerView = screen.headerView {
                            NavigationLink(
                                destination: { DebugSDView(view: headerView) },
                                label: { Text("Header") }
                            )
                        }
                        
                        NavigationLink(
                            destination: { DebugSDView(view: screen.someView) },
                            label: { Text("Body") }
                        )
                        
                        if let footerView = screen.footerView {
                            NavigationLink(
                                destination: { DebugSDView(view: footerView) },
                                label: { Text("Footer") }
                            )
                        }
                    },
                    header: { Text("Views") }
                )
                
                Section(
                    content: {
                        ForEach(screen.destinations, id: \.self) { destination in
                            SDLabel(
                                label: SomeLabel(
                                    title: destination.toID,
                                    font: .body,
                                    destination: destination
                                )
                            )
                        }
                    },
                    header: { Text("Destinations") }
                )
            }
        }
    }
}

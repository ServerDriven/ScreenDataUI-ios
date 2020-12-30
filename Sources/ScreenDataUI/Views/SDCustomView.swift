//
//  SDCustomView.swift
//  
//
//  Created by Zach Eriksen on 12/28/20.
//

import SwiftUI
import ScreenData

public protocol SDCustomizedView {
    var id: String { get }
    
    func view(forSomeCustomView customView: SomeCustomView) -> AnyView
}

public struct SDCustomView: View {
    public static var customViews: [String: SDCustomizedView] = [:]
    public static func add(customView: SDCustomizedView) {
        customViews[customView.id] = customView
    }
    
    public var custom: SomeCustomView
    
    public init(custom: SomeCustomView) {
        self.custom = custom
    }
    
    public var body: some View {
        guard let id = custom.id,
              let customView = SDCustomView.customViews[id] else {
            return AnyView(
                Text("404")
                    .font(.title)
                    .foregroundColor(.red)
            )
        }
        
        return customView.view(forSomeCustomView: custom)
    }
}

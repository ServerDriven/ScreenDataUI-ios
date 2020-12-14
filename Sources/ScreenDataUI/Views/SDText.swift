//
//  SDText.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import SwiftUI
import ScreenData

public struct SDText: View {
    public var text: SomeText
    
    public init(text: SomeText) {
        self.text = text
    }
    
    public var body: some View {
        Text(text.title)
            .background(with: text.style)
        
    }
}

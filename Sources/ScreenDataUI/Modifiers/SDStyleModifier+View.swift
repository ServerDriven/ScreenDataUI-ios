import SwiftUI
import ScreenData

public extension SwiftUI.View {
    func background(with style: ScreenData.Style) -> some SwiftUI.View {
        self.modifier(SDStyleModifier(style: style))
    }
}

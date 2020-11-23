import SwiftUI
import ScreenData

public extension View {
    func background(with style: SomeStyle?) -> some View {
        self.modifier(SDStyleModifier(style: style ?? SomeStyle()))
    }
}

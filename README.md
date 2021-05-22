# ScreenDataUI

*ServerDriven SwiftUI Views using [ScreenData](https://serverdriven.github.io/ScreenData/)*


## Usage

```swift
import ScreenData
import ScreenDataUI
```


You will need to also `import ScreenDataNavigation` if you are dealing with `ScreenProviding` or `ScreenStoring`.

### SDScreen Example

```swift
SDScreen(
    screen: SomeScreen(
        title: "Hello, World!",
        backgroundColor: SomeColor(red: 1, green: 1, blue: 1),
        someView: SomeLabel(title: "👋", font: .largeTitle).someView
    )
)
```

*Note: The title will only show up if there is a NavigationView*

### ScreenProvider Example

#### ScreenProvider
```swift
import ScreenDataNavigation

struct ScreenProvider: ScreenProviding {
    func screen(forID id: String) -> AnyPublisher<SomeScreen, Error> {
        Just(
            SomeScreen(
                title: "Hello, World!",
                backgroundColor: SomeColor(red: 1, green: 1, blue: 1),
                someView: SomeLabel(title: "👋 \(id)", font: .largeTitle).someView
            )
        )
        .mapError { Never -> Error in }
        .eraseToAnyPublisher()
    }
}
```

#### ScreenProviderStore

```swift
class ScreenProviderStore: ObservableObject {
    private var task: AnyCancellable?
    
    @Published var screen: SomeScreen?
    
    func fetch(screenID id: String) {
        task = ScreenProvider().screen(forID: id)
            .sink(
                receiveCompletion: { _ in },
                receiveValue:{ screen in
                    DispatchQueue.main.async {
                        self.screen = screen
                    }
                }
            )
    }
}
```

#### ScreenDataContentView

```swift
struct ScreenDataContentView: View {
    @StateObject private var store = ScreenProviderStore()
    
    public var baseID: String
    
    var body: some View {
        guard let screen = store.screen else {
            return AnyView(
                ProgressView()
                    .onAppear {
                        store.fetch(screenID: baseID)
                    }
            )
        }
        
        return AnyView(
            NavigationView {
                SDScreen(screen: screen)
            }
        )
    }
}
```

#### Example SDCustomizedView

```swift
import SwiftUI
import ScreenData
import ScreenDataUI

struct DividerView: SDCustomizedView {
    var id: String {
        "dividerView"
    }
    
    func view(forSomeCustomView customView: SomeCustomView) -> AnyView {
        AnyView(Divider().background(with: customView.style))
    }
}
```

## Configuration

Before showing a `SDScreen` you can override the ScreenDataUI default values. You can also add your own custom views that conform to `SDCustomizedView`.

```swift
// MARK: SDScreenProvider default

SDScreenProvider.default = ScreenProvider()

// MARK: SDScreenStore default
// UserDefaultScreenStorer is from ScreenDataNavigation

SDScreenStore.default = UserDefaultScreenStorer(baseKey: "example")

// MARK: SDCustomViews
// Views that conform to SDCustomizedView

SDCustomView.add(customView: DividerView())

// MARK: Default Colors
//

SDImage.defaultForegroundColor = .white

// MARK: SDButton Actions
//

SDButton.add(actionWithID: "some.id") {
    print("Button Tapped!")
}

// MARK: SDFont Values
//

SDFont.largeTitleFont = Font.custom("Thonburi", size: 34, relativeTo: .largeTitle)
SDFont.titleFont = Font.custom("Thonburi", size: 28, relativeTo: .title)
SDFont.headlingFont = Font.custom("Thonburi-Bold", size: 17, relativeTo: .headline)
SDFont.bodyFont = Font.custom("Thonburi", size: 17, relativeTo: .body)
SDFont.footnoteFont = Font.custom("Thonburi", size: 13, relativeTo: .footnote)
SDFont.captionFont = Font.custom("Futura-Bold", size: 12, relativeTo: .caption)
```

import SwiftUI
import Combine

public class ImageLoader: ObservableObject {
    @Published public var image: UIImage?
    private let url: URL?
    private var cancellable: AnyCancellable?
    
    public init(url: URL?) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    public func load() {
        guard let url = url else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    public func cancel() {
        cancellable?.cancel()
    }
}

public struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    public init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    public var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}

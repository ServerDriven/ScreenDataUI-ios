//
//  SomeView+.swift
//  
//
//  Created by Zach Eriksen on 11/22/20.
//

import ScreenData

public extension SomeLabel {
    var someView: SomeView {
        SomeView(type: .label, someLabel: self)
    }
}

public extension SomeText {
    var someView: SomeView {
        SomeView(type: .text, someText: self)
    }
}

public extension SomeLabeledImage {
    var someView: SomeView {
        SomeView(type: .labeledImage, someLabeledImage: self)
    }
}

public extension SomeImage {
    var someView: SomeView {
        SomeView(type: .image, someImage: self)
    }
}

public extension SomeCustomView {
    var someView: SomeView {
        SomeView(type: .custom, someCustomView: self)
    }
}

public extension SomeContainerView {
    var someView: SomeView {
        SomeView(type: .container, container: self)
    }
}

public extension SomeButton {
    var someView: SomeView {
        SomeView(type: .button, someButton: self)
    }
}

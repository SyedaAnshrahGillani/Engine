//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import EngineCore

extension AnyView {

    /// Creates a type-erased view from a type-erased value if that value is also a `View`
    public static func make(from content: Any) -> AnyView? {
        AnyView(visiting: content)
    }
}

// MARK: - Previews

struct AnyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnyView.make(from: Optional<String>.none as Any)

            let content: Any = Text("Hello, World")
            AnyView.make(from: content)
        }
    }
}

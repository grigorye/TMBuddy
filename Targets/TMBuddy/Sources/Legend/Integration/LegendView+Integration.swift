import SwiftUI

extension LegendView {
    
    static func new() -> some View {
        Self(
            state: .init(),
            actions: LegendViewActionsHandler()
        )
    }
}

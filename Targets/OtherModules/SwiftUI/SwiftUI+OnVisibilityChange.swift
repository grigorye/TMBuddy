import SwiftUI

extension View {
    
    func onVisibilityChange(perform handler: ((Bool) -> Void)?) -> some View {
        self
            .onAppear(perform: { handler?(true) })
            .onDisappear(perform: { handler?(false) })
    }
}

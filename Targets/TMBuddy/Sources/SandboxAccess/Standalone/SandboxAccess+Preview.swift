import SwiftUI

struct SandboxAccessView_Previews : PreviewProvider {
    
    static var previews: some View {
        SandboxAccessView(
            state: .init(
                showPostSMJobBless: true,
                showPostInstall: true,
                showDebug: true
            )
        )
        .padding()
    }
}

import SwiftUI

@available(macOS 11.0, *)
@SceneBuilder
@MainActor
func mainScene(content: @escaping () -> some View) -> some Scene {
    MainScene {
        content()
    }
}

@available(macOS 11.0, *)
struct MainScene<Content: View>: Scene {
    let content: () -> Content
    
    var body: some Scene {
        Settings {
            content()
        }
    }
}

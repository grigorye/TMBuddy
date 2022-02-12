import SwiftUI

func ObservableWrapperView<Content: View>(content: @escaping () -> Content) -> some View {
    content()
}

func ObservableWrapperView<Content: View, O1: ObservableObject>(_ o1: O1, content: @escaping (O1) -> Content) -> some View {
    ObservableWrapperView1(o1: o1, content: content)
}

func ObservableWrapperView<Content: View, O1: ObservableObject, O2: ObservableObject>(_ o1: O1, _ o2: O2, content: @escaping (O1, O2) -> Content) -> some View {
    ObservableWrapperView2(o1: o1, o2: o2, content: content)
}

private struct ObservableWrapperView1<Content: View, O1: ObservableObject>: View {
    
    @ObservedObject var o1: O1
    
    let content: (O1) -> Content
    
    var body: some View {
        content(o1)
    }
}

private struct ObservableWrapperView2<Content: View, O1: ObservableObject, O2: ObservableObject>: View {
    
    @ObservedObject var o1: O1
    @ObservedObject var o2: O2
    
    let content: (O1, O2) -> Content
    
    var body: some View {
        content(o1, o2)
    }
}

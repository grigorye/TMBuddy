import Foundation

func adjustForSrcRootRelocation(file: String) -> String {
    let oldSrcRoot = ProcessInfo().environment["OLD_SRCROOT"]
    let newSrcRoot = ProcessInfo().environment["SRCROOT"]
    
    guard let newSrcRoot, let oldSrcRoot else {
        assert(oldSrcRoot == nil, "OLD_SRCROOT is set, but SRCROOT is not.")
        return file
    }
    
    return adjust(file: file, forSrcRoot: oldSrcRoot, changedTo: newSrcRoot)
}

private func adjust(file: String, forSrcRoot oldSrcRoot: String, changedTo newSrcRoot: String) -> String {
    // SRCROOT may be somewhere below the root of the actual tree: it's fine, as long as its relative location remains the same.
    
    let oldBase = oldSrcRoot.commonPrefix(with: file)
    let oldSuffix = oldSrcRoot[oldBase.endIndex...]
    let newBase = newSrcRoot.dropLast(oldSuffix.count)
    
    assert(file.hasPrefix(oldBase))
    
    return file.replacingOccurrences(of: oldBase, with: newBase, options: .anchored)
}

import XCTest

class Path_SrcRootRelocation_Tests: XCTestCase {
    
    func testAdjustForChangedSrcRoot() {
        XCTAssertEqual(
            adjust(
                file: "/Users/user-1/Foo/Bar/Baz/Source.swift",
                forSrcRoot: "/Users/user-1/Foo/Bar/Project",
                changedTo: "/Users/user-2/Foo/Bar/Project"
            ),
            "/Users/user-2/Foo/Bar/Baz/Source.swift"
        )
    }
}

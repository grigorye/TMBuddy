//
// CAUTION! DON'T MOVE THIS FILE IN THE SOURCE TREE UNLESS YOU FOLLOW INSTRUCTIONS BELOW.
//
// A bit of magic to derive the source tree location.
//
// The *name* of this file should be SourceLevel-N, where
// N is the number of path components from this file towards the root of the source tree.
//
// E.g. if this file is placed in the root of the source tree, it should have name "SourceLevel-0.swift"
//

import Foundation

let srcRoot: String = {
    let levelsString = URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent.split(separator: "-").last!
    let levels = Int(levelsString)!
    return NSString.path(withComponents: (#file as NSString).pathComponents.dropLast(levels + 1))
}()

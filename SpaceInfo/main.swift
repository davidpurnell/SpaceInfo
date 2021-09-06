//
//  main.swift
//  SpaceInfo
//
//  Created by David Purnell on 8/20/21.
//

import Foundation

@objc
class Space: NSObject {
    let mainDisplay = "Main"
    let conn = _CGSDefaultConnection()

    @objc func SpaceInfo(info: String, verbose: Bool) -> String {
        let displays = CGSCopyManagedDisplaySpaces(conn) as! [NSDictionary]
        let activeDisplay = CGSCopyActiveMenuBarDisplayIdentifier(conn) as! String
        let allSpaces: NSMutableArray = []
        var activeSpaceID = -1
        var totalDisplays = 0
        var totalSpaces = 0
        var curSpace = 0
        var curDisplay = 0
        var theInfo = ""
        for d in displays {
            totalDisplays += 1
            guard
                let current = d["Current Space"] as? [String: Any],
                let spaces = d["Spaces"] as? [[String: Any]],
                let dispID = d["Display Identifier"] as? String
                else {
                    continue
            }

            switch dispID {
            case mainDisplay, activeDisplay:
                curDisplay = totalDisplays
                activeSpaceID = current["ManagedSpaceID"] as! Int
            default:
                break
            }

            for s in spaces {
                totalSpaces += 1
                let isFullscreen = s["TileLayoutManager"] as? [String: Any] != nil
                if isFullscreen {
                    continue
                }
                allSpaces.add(s)
            }
        }

        for (index, space) in allSpaces.enumerated() {
            let spaceID = (space as! NSDictionary)["ManagedSpaceID"] as! Int
            let spaceNumber = index + 1
            if spaceID == activeSpaceID {
                //print(spaceNumber)
                curSpace = spaceNumber
            }
        }
        switch info {
        case "--current-display":
            theInfo = verbose ? "current display: \(curDisplay)\n" : String(describing:curDisplay)
        case "--total-displays":
            theInfo = verbose ? "total displays: \(totalDisplays)\n" : String(describing:totalDisplays)
        case "--current-space":
            theInfo = verbose ? "current space: \(curSpace)\n" : String(describing: curSpace)
        case "--total-spaces":
            theInfo = verbose ? "total spaces: \(totalSpaces)\n" : String(describing: totalSpaces)
        case "--verbose":
            break
        default: break
        }
        return theInfo
    }
    
    func printUsage(name: String) -> String {
        let usage = """
                        Usage:  \(name) [OPTIONS]
                        \t--verbose  Verbose output
                        \t--current-space  Current active space
                        \t--current-display  Current active display
                        \t--total-spaces  Total spaces
                        \t--total-displays  Total displays"
                        """
        return usage
    }

    func separate(theValue: String, separator: String = " ", stride: Int = 1) -> String {
        return theValue.enumerated().map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }.joined()
    }
}

let args = CommandLine.arguments
if (args.count > 1) {
    let verbose = args.firstIndex(of: "--verbose") != nil ? true : false
    var theInfo = ""
    for i in args {
        if i != "--verbose" { theInfo += Space().SpaceInfo(info: i, verbose: verbose) }
    }
    if theInfo == "" {
        print(Space().printUsage(name: args[0]))
    } else {
        print(verbose ? theInfo : Space().separate(theValue: theInfo))
    }
} else {
    print(Space().printUsage(name: args[0]))
}

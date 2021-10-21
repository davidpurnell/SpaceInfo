//
//  Space.swift
//
//  this functionality adapted from WhichSpace (https://github.com/gechr/WhichSpace)
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@objc
class Space: NSObject {
    
    let mainDisplay = "Main"
    let conn = _CGSDefaultConnection()

    @objc func SpaceInfo(info: String, verbose: Bool, display: Int) -> String {
        let displays = CGSCopyManagedDisplaySpaces(conn) as! [NSDictionary]
        let curDisplay = CGSCopyActiveMenuBarDisplayIdentifier(conn) as! String
        let allSpaces: NSMutableArray = []
        var spaceCount: [Int] = []
        var activeSpaceID = -1
        var totalDisplays = 0
        var activeSpace = 0
        var activeDisplay = 0
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
            spaceCount.append(spaces.count)

            switch dispID {
            case mainDisplay, curDisplay:
                activeDisplay = totalDisplays
                activeSpaceID = current["ManagedSpaceID"] as! Int
            default:
                break
            }

            for s in spaces {
                let isFullscreen = s["TileLayoutManager"] as? [String: Any] != nil
                if isFullscreen {
                    continue
                }
                allSpaces.add(s)
            }
        }
        let totalSpaces = allSpaces.count
        
        for (index, space) in allSpaces.enumerated() {
            let spaceID = (space as! NSDictionary)["ManagedSpaceID"] as! Int
            let spaceNumber = index + 1
            if spaceID == activeSpaceID {
                activeSpace = spaceNumber
            }
        }
        
        switch info {

        case "activeDisplay":
            theInfo = verbose ? "active display: \(activeDisplay)\n" : String(describing:activeDisplay)
        case "totalDisplays":
            theInfo = verbose ? "total displays: \(totalDisplays)\n" : String(describing:totalDisplays)
        case "activeSpace":
            theInfo = verbose ? "active space: \(activeSpace)\n" : String(describing: activeSpace)
        case "totalSpaces":
            if let theCount: Int = spaceCount[safe: display - 1] {
                theInfo = verbose ? "total spaces for display #\(display): \(theCount)\n" : String(describing: theCount)
            } else {
                if display == 99 {
                    theInfo = verbose ? "total spaces: \(totalSpaces)\n" : String(describing: totalSpaces)
                } else {
                    theInfo = verbose ? "error: an invalid display index was specified\n" : String(describing: 0)
                }
            }
        default: break
        }
        return theInfo
    }
}

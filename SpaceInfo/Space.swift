//
//  Space.swift
//

import Foundation

@objc
class Space: NSObject {
    let mainDisplay = "Main"
    let conn = _CGSDefaultConnection()

    @objc func SpaceInfo(info: String, verbose: Bool) -> String {
        let displays = CGSCopyManagedDisplaySpaces(conn) as! [NSDictionary]
        let curDisplay = CGSCopyActiveMenuBarDisplayIdentifier(conn) as! String
        let allSpaces: NSMutableArray = []
        var activeSpaceID = -1
        var totalDisplays = 0
        var totalSpaces = 0
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

            switch dispID {
            case mainDisplay, curDisplay:
                activeDisplay = totalDisplays
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
            theInfo = verbose ? "total spaces: \(totalSpaces)\n" : String(describing: totalSpaces)
        default: break
        }
        return theInfo
    }
}

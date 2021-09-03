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
    let theNum = 1
    let conn = _CGSDefaultConnection()

    @objc func updateActiveSpaceNumber() {
        let displays = CGSCopyManagedDisplaySpaces(conn) as! [NSDictionary]
        let activeDisplay = CGSCopyActiveMenuBarDisplayIdentifier(conn) as! String
        let allSpaces: NSMutableArray = []
        var activeSpaceID = -1

        for d in displays {
            guard
                let current = d["Current Space"] as? [String: Any],
                let spaces = d["Spaces"] as? [[String: Any]],
                let dispID = d["Display Identifier"] as? String
                else {
                    continue
            }

            switch dispID {
            case mainDisplay, activeDisplay:
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

        for (index, space) in allSpaces.enumerated() {
            let spaceID = (space as! NSDictionary)["ManagedSpaceID"] as! Int
            let spaceNumber = index + 1
            if spaceID == activeSpaceID {
                print(spaceNumber)
                return
            }
        }
    }
}

Space().updateActiveSpaceNumber()

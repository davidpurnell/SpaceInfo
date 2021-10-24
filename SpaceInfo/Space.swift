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

        struct displayInfo {
            var totalSpaces: Int
            var firstSpace: Int
            var lastSpace: Int
        }
        var theDisplays = [displayInfo]()
        
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

            switch dispID {
            case mainDisplay, curDisplay:
                activeDisplay = totalDisplays
                activeSpaceID = current["ManagedSpaceID"] as! Int
            default:
                break
            }

            let displaySpaces: NSMutableArray = []
            
            for s in spaces {
                let isFullscreen = s["TileLayoutManager"] as? [String: Any] != nil
                if isFullscreen {
                    continue
                }
                
                allSpaces.add(s)
                displaySpaces.add(s)
            }

            theDisplays.append(displayInfo(totalSpaces: displaySpaces.count, firstSpace: (displaySpaces.firstObject as! NSDictionary)["ManagedSpaceID"] as! Int, lastSpace: (displaySpaces.lastObject as! NSDictionary)["ManagedSpaceID"] as! Int))
        }
        let totalSpaces = allSpaces.count
        
        for (index, space) in allSpaces.enumerated() {
            let spaceID = (space as! NSDictionary)["ManagedSpaceID"] as! Int
            let spaceNumber = index + 1
            for i in 0..<theDisplays.count {
                if spaceID == theDisplays[i].firstSpace {
                    theDisplays[i].firstSpace = spaceNumber
                } else if spaceID == theDisplays[i].lastSpace {
                    theDisplays[i].lastSpace = spaceNumber
                }
            }
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
            if let theCount: Int = theDisplays[safe: display - 1]?.totalSpaces {
                theInfo = verbose ? "total spaces for display #\(display): \(theCount)\n" : String(describing: theCount)
            } else {
                if display == 99 {
                    theInfo = verbose ? "total spaces: \(totalSpaces)\n" : String(describing: totalSpaces)
                } else {
                    theInfo = verbose ? "error: an invalid display index was specified\n" : String(describing: 0)
                }
            }
        case "firstSpace":
            if let theCount: Int = theDisplays[safe: display - 1]?.firstSpace {
                theInfo = verbose ? "first space for display #\(display): \(theCount)\n" : String(describing: theCount)
            } else {
                if display == 99 {
                    theInfo = verbose ? "first space: 1\n" : "1"
                } else {
                    theInfo = verbose ? "error: an invalid display index was specified\n" : String(describing: 0)
                }
            }
        case "lastSpace":
            if let theCount: Int = theDisplays[safe: display - 1]?.lastSpace {
                theInfo = verbose ? "last space for display #\(display): \(theCount)\n" : String(describing: theCount)
            } else {
                if display == 99 {
                    theInfo = verbose ? "last space: \(allSpaces.count)\n" : String(describing: allSpaces.count)
                } else {
                    theInfo = verbose ? "error: an invalid display index was specified\n" : String(describing: 0)
                }
            }
        default: break
        }
        return theInfo
    }
}

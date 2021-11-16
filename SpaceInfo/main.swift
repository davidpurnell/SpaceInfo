//
//  main.swift
//  SpaceInfo
//
//  Created by David Purnell on 8/20/21.
//
import ArgumentParser

enum Flags: String, EnumerableFlag {
    case activeDisplay, totalDisplays, activeSpace, firstSpace, lastSpace, totalSpaces, testing
}

struct Spaceinfo: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            version: "1.3.1"
        )
    }
    @Flag(help: " ") var options: [Flags] = []
    @Option(name: .short, help: "Restrict total spaces info to a specific display number") var display: Int?
    @Flag(name: .short, help: "Verbose output") var verbose = false
    
    mutating func validate() throws {
        if (options.isEmpty) {
          throw ValidationError("provide at least one switch\n")
        }
    }
    
    func separate(theValue: String, separator: String = " ", stride: Int = 1) -> String {
        return theValue.enumerated().map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }.joined()
    }
    
    func run() {
        //
        var theInfo = ""
        for i in options {
            theInfo += Space().SpaceInfo(info: i.rawValue, verbose: verbose, display: display ?? 99)
        }
                
        print(verbose ? theInfo : separate(theValue: theInfo))
    }
}

Spaceinfo.main()

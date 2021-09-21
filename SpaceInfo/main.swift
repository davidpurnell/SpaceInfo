//
//  main.swift
//  SpaceInfo
//
//  Created by David Purnell on 8/20/21.
//
import ArgumentParser

enum Option: String, EnumerableFlag {
    case activeDisplay, totalDisplays, activeSpace, totalSpaces
}

struct SpaceInfo: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            version: "1.1.2"
        )
    }
    @Flag(help: " ") var options: [Option] = []
    @Flag(name: .short, help: "verbose output") var verbose = false

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
            theInfo += Space().SpaceInfo(info: i.rawValue, verbose: verbose)
            //print("option chosen: \(i) (verbose)")
        }
        print(verbose ? theInfo : separate(theValue: theInfo))
    }
}

SpaceInfo.main()

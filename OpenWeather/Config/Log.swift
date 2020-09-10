//
//  Log.swift
//  ModuleCommons
//
//  Created by Florian on 01.11.19.
//  Copyright © 2019 Victor Kachalov. All rights reserved.
//

import Foundation

enum Level: String {
    case inf
    case dbg
    case wrg
    case err
}

public func logDebug(
    _ message: Any?,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    #if DEVELOPMENT
    log(
        message: message,
        level: .dbg,
        file: file,
        line: line,
        function: function
    )
    #endif
}
public func logInfo(
    _ message: Any?,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    log(
        message: message,
        level: .inf,
        file: file,
        line: line,
        function: function
    )
}
public func logError(
    _ message: Any?,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    log(
        message: message,
        level: .err,
        file: file,
        line: line,
        function: function
    )
}
public func logWarning(
    _ message: Any?,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    log(
        message: message,
        level: .wrg,
        file: file,
        line: line,
        function: function
    )
}

private func log(
    message: Any?,
    level: Level,
    file: String,
    line: Int,
    function: String
) {
    let logLevel = level.rawValue.uppercased()
    let logTime = Date()
    let place = (file as NSString).lastPathComponent
    print("[\(logLevel)/\(logTime)]: [\(place):\(line) #\(function)] \(message ?? "")")
}

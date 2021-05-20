//
//  Logger.swift
//  
//
//  Created by Leif on 5/19/21.
//

import Chronicle

public enum ScreenDataUILogger {
    public static var formatter: ChronicleFormatter = Chronicle.DefaultFormatters.DefaultFormatter()
    
    public static var handler: ChronicleHandler = Chronicle.DefaultHandlers.PrintHandler()
    
    public static let console = Chronicle(
        label: "screendata.ui.ios",
        formatter: ScreenDataUILogger.formatter,
        handler: ScreenDataUILogger.handler
    )
}

func log(level: Chronicle.LogLevel) {
    ScreenDataUILogger.console.log(level: level)
}

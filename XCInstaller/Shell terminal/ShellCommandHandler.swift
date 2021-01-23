//
//  ShellCommandHandler.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//
import Foundation
import Cocoa

protocol ShellCommandDelegate: class {
    func shellCommandDidFinish(_ exitcode:Int, with handler: ShellCommandHandler)
    func shellCommandDidOutputData(_ response:String, with handler: ShellCommandHandler)
    func shellCommandDidReceiveError(_ data:Data, with handler: ShellCommandHandler)
}

class ShellCommandHandler: NSObject {
    private var task:Process
    private var outputPipe:Pipe
    private var errorPipe:Pipe
    private var inputPipe:Pipe
    private var delegate:ShellCommandDelegate?
    private var queue:DispatchQueue?
    
    override init() {
        task = Process()
        outputPipe = Pipe()
        inputPipe = Pipe()
        errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.standardInput = inputPipe
        super.init()
    }
    
    
    public func isExecuting() -> Bool {
        return task.isRunning
    }
    
    public func stopExecuting() {
        self.task.terminate()
    }
    
    private func setDelegate(_ delegate: ShellCommandDelegate){
        self.delegate = delegate
    }
    
    private func setExecutablePath(_ path: String){
        self.task.launchPath = path
    }
    
    private func setArguments(_ arguments:[String]) {
        guard arguments.count > 0 else { return }
        self.task.arguments = arguments
    }
    
    func execute(){
        queue = DispatchQueue.global(qos: .background)
        queue?.async {
            self.task.terminationHandler = { _ in
                DispatchQueue.main.async {
                    self.delegate?.shellCommandDidFinish(Int(self.task.terminationStatus), with: self)
                }
            }
            self.observePipeChanges(for: self.task)
            self.task.launch()
            self.task.waitUntilExit()
        }
        
    }
    
    private func observePipeChanges(for task:Process){
        self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        self.errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        // Outout
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading, queue: nil) { (notfication) in
            let standardResult = self.outputPipe.fileHandleForReading.availableData
            let resultString = String(data: standardResult, encoding: String.Encoding.utf8) ?? ""
            
            if !resultString.isEmpty {
                DispatchQueue.main.async {
                    self.delegate?.shellCommandDidOutputData(resultString, with: self)
                }
                
                self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            }
        }
    }
}

extension ShellCommandHandler {
    
    class func getCommandHandler(path executablePath : String,
                                            arguments : [String],
                                            delegate  : ShellCommandDelegate) -> ShellCommandHandler{
        
        let commandTerminal = ShellCommandHandler()
        commandTerminal.setExecutablePath(executablePath)
        commandTerminal.setArguments(arguments)
        commandTerminal.setDelegate(delegate)
        return commandTerminal
    }
}

//
//  ShellCommandHandler.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//
import Foundation
import Cocoa



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
        
        // Output
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading, queue: nil) { (notfication) in
            let standardResult = self.outputPipe.fileHandleForReading.availableData
            let resultString = String(data: standardResult, encoding: String.Encoding.utf8) ?? ""
            
            if !resultString.isEmpty {
               
                DispatchQueue.main.async {
                     print(resultString)
                    self.delegate?.shellCommandDidOutputData(standardResult, with: self)
                }
                
                self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            }
        }
        
        // STD Error
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: self.errorPipe.fileHandleForReading, queue: nil) { (notification) in
            
            let errorData = self.errorPipe.fileHandleForReading.availableData
            let resultString = String(data: errorData, encoding: String.Encoding.utf8) ?? ""
            
            if !resultString.isEmpty {
                print(resultString)
                DispatchQueue.main.async {
                    self.delegate?.shellCommandDidReceiveError(errorData, with: self)
                }
                self.errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            }
        }
        
        //Termination
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSThreadWillExit, object: task, queue: nil) { (notfication) in
            self.delegate?.shellCommandDidFinish(Int(self.task.terminationStatus), with: self)
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

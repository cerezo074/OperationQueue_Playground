//: Playground - noun: a place where people can play

import UIKit
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*
 USING BlockOperation Class
 
 The solutions 1 and 2 are only example for working with the BlockOperations Class
 */

class Task: Counter {
    
    var taskName: String
    var stop: Bool = false
    
    required init(taskName: String) {
        self.taskName = taskName
    }
    
    class func playSound(_ sound: String) {
        print("Playing sound named: \(sound)")
        let task = Task(taskName: "Play Sound")
        task.start(1, 10)
        print("\(sound) sound was played!!!")
    }
    
    class func downloadFriends() {
        print("Downloading friends")
        let task = Task(taskName: "Download Friends")
        task.start(1, 5)
        print("Friends Downloaded!!!")
    }
    
    class func downloadConfigurationFile() {
        print("Downloading config file")
        let task = Task(taskName: "Download Config File")
        task.start(1, 3)
        print("Config file downloaded!!!")
    }
    
    class func saveDataConfiguration() {
        print("Saving config file")
        let task = Task(taskName: "Save Config File")
        task.start(1, 7)
        print("Configurartion file saved!!!")
    }
    
}

protocol Counter {
    var taskName: String { get set }
    var stop: Bool { get }
    init(taskName: String)
}

extension Counter {
    
    func start(_ from: Int, _ to: Int) {
        if from >= to {
            print("Error, the counter can't be initialized on \(taskName)")
            return
        }
        
        if stop {
            print("Counter has been stopped on \(taskName)")
            return
        }
        
        print("Counter has been started on \(taskName)")
        for number in from ... to {
            Thread.sleep(forTimeInterval: 1.0)
            print("Thread: \(Thread.current)\nTime elapsed \(number) seconds on \(taskName)")
            
            if stop {
                print("Counter has been stopped on \(taskName)")
                return
            }
        }
        
        print("Counter has finished on \(taskName)")
    }
    
}

let taskQueue = OperationQueue()
taskQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
taskQueue.name = "My Tasks"

//let soundTask = BlockOperation {
//    Task.playSound("Dog")
//}

// MARK: Solution 1

//let downloadFriendsTask = BlockOperation {
//    Task.downloadFriends()
//}

//let configTasks = BlockOperation {
//    Task.downloadConfigurationFile()
//    Task.saveDataConfiguration()
//}

//taskQueue.addOperations([soundTask, downloadFriendsTask, configTasks], waitUntilFinished: false)

//MARK: Solution 2

//soundTask.addExecutionBlock {
//    Task().downloadFriends()
//}
//
//soundTask.addExecutionBlock {
//    let task = Task()
//    task.downloadConfigurationFile()
//    task.saveDataConfiguration()
//}
//
//taskQueue.addOperation(soundTask)

/*
 USING NSOperation Class
 
 This example has the same aproach than for BlockOperation
 */

//MARK: Solution 1

//class PlaySoundOperation: Operation, Counter {
//    var stop: Bool {
//        return isCancelled
//    }
//    var taskName: String
//    
//    required init(taskName: String) {
//        self.taskName = taskName
//    }
//    
//    override func main() {
//        print("Playing sound named: Dog")
//        start(1, 10)
//    }
//    
//}
//
//class DownloaderFriendsOperation: Operation, Counter {
//    var stop: Bool {
//        return isCancelled
//    }
//    var taskName: String
//    
//    required init(taskName: String) {
//        self.taskName = taskName
//    }
//    
//    override func main() {
//        print("Downloading friends")
//        start(1, 5)
//    }
//}
//
//class DownloaderConfigFileOperation: Operation, Counter {
//    var stop: Bool {
//        return isCancelled
//    }
//    var taskName: String
//    
//    required init(taskName: String) {
//        self.taskName = taskName
//    }
//    
//    override func main() {
//        print("Downloading config file")
//        start(1, 3)
//    }
//}
//
//class SaverConfigFileOperation: Operation, Counter {
//    var stop: Bool {
//        return isCancelled
//    }
//    var taskName: String
//    
//    required init(taskName: String) {
//        self.taskName = taskName
//    }
//    
//    override func main() {
//        print("Saving config file")
//        start(1, 7)
//    }
//}

// MARK: Solution 2

class Operator: Operation {
 
    var operatorHasFinished: Bool = false {
        didSet{
            didChangeValue(forKey: "isFinished")
        }
        willSet{
            willChangeValue(forKey: "isFinished")
        }
    }
    var operatorIsExecuting: Bool = false {
        didSet{
            didChangeValue(forKey: "isExecuting")
        }
        willSet{
            willChangeValue(forKey: "isExecuting")
        }
    }

    override var isExecuting: Bool {
        return operatorIsExecuting
    }
    
    override var isFinished: Bool {
        return operatorHasFinished
    }
    
    override var isConcurrent: Bool {
        return true
    }
    
    func taskCompleted() {
        operatorIsExecuting = false
        operatorHasFinished = false
    }
    
    override func start() {
        if isCancelled {
            operatorHasFinished = true
            return
        }
        
        Thread.detachNewThreadSelector(#selector(Operation.main), toTarget: self, with: nil)
        operatorIsExecuting = true
    }
    
}

class PlaySoundOperation: Operator, Counter {
    
    var taskName: String
    var stop: Bool {
        return isCancelled
    }
    
    required init(taskName: String) {
        self.taskName = taskName
    }
    
    override func main() {
        print("Playing sound named: Dog")
        start(1, 10)
        taskCompleted()
    }
    
}

class DownloaderFriendsOperation: Operator, Counter {
    var stop: Bool {
        return isCancelled
    }
    var taskName: String
    
    required init(taskName: String) {
        self.taskName = taskName
    }
    
    override func main() {
        print("Downloading friends")
        start(1, 5)
        taskCompleted()
    }
}

class DownloaderConfigFileOperation: Operator, Counter {
    var stop: Bool {
        return isCancelled
    }
    var taskName: String
    
    required init(taskName: String) {
        self.taskName = taskName
    }
    
    override func main() {
        print("Downloading config file")
        start(1, 3)
        taskCompleted()
    }
}

class SaverConfigFileOperation: Operator, Counter {
    var stop: Bool {
        return isCancelled
    }
    var taskName: String
    
    required init(taskName: String) {
        self.taskName = taskName
    }
    
    override func main() {
        print("Saving config file")
        start(1, 7)
        taskCompleted()
    }
}

let playSoundOperation = PlaySoundOperation(taskName: "Play Sound")
playSoundOperation.completionBlock = {
    if !playSoundOperation.isCancelled {
        print("Dog sound was played!!!")
    }
    else {
        print("Play Sound operation was cancelled")
    }
}

let downloadFriendsOperation = DownloaderFriendsOperation(taskName: "Download Friends")
downloadFriendsOperation.completionBlock = {
    if !downloadFriendsOperation.isCancelled {
        print("Friends Downloaded!!!")
    }
    else {
        print("Download Friends operation was cancelled")
    }
}

let downloadConfigFileOperation = DownloaderConfigFileOperation(taskName: "Download Config File")
downloadConfigFileOperation.completionBlock = {
    if !downloadConfigFileOperation.isCancelled {
        print("Config file downloaded!!!")
    }
    else {
        print("Save config file operation was cancelled")
    }
}

let saveConfigFile = SaverConfigFileOperation(taskName: "Save Config File")
saveConfigFile.completionBlock = {
    if !saveConfigFile.isCancelled {
        print("Configurartion file saved!!!")
    }
    else {
        print("Save config file operation was cancelled")
    }
}
saveConfigFile.addDependency(downloadConfigFileOperation)

playSoundOperation.start()
downloadFriendsOperation.start()
downloadConfigFileOperation.start()
saveConfigFile.start()

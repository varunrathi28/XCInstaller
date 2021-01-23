//
//  DeviceDataStore.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation
import AppKit
import CoreData


class DeviceDataStore {
    
  private  let deviceEntityName = "Device"
  private  var mainContext: NSManagedObjectContext =  {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        return context
    }()
    
  public  func getSimulatorDevicesList() -> [Device]? {
        let fetchRequest: NSFetchRequest<Device> = Device.fetchRequest()
        do {
            if let result:[Device] = try mainContext.fetch(fetchRequest), !result.isEmpty {
                return result
            }
        }
        catch{
            print("Failed to fetch device list")
        }
        return nil
    }
    
   public func saveSimulatorListToStore( devices : [[String:AnyObject]]) {
        guard devices.isEmpty == false else { return }
        mainContext.perform {
            devices.forEach { dic in
                guard let udid = dic["udid"] as? String else { return }
                if !self.checkIfDeviceExists(for: udid, in: self.mainContext) {
                     self.insertDeviceEntity(dic, in: self.mainContext)
                }
            }

            do {
                try self.mainContext.save()
            }
            catch {
                print("Unnable to save device: \(error)")
            }
        }
    }
    
   fileprivate func insertDeviceEntity(_ dic: [String:AnyObject],  in context: NSManagedObjectContext) {
         guard let udid = dic["udid"] as? String else { return }
        
        if let deviceEntity = NSEntityDescription.entity(forEntityName: deviceEntityName, in: context) {
            if  let  deviceObj = NSManagedObject(entity: deviceEntity, insertInto: context) as? Device {
        
                deviceObj.udid = udid
                deviceObj.name = dic["name"] as? String
                deviceObj.available = dic["available"] as? Bool ?? false
                deviceObj.state = dic["state"] as? String
                
            }
        }
    }
    
    fileprivate func checkIfDeviceExists(for udid:String, in context: NSManagedObjectContext) -> Bool {
           let fetchRequest: NSFetchRequest<Device> = Device.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "%K = %@","udid",udid)
           fetchRequest.fetchLimit = 1
           do {
               if let result = try context.fetch(fetchRequest) as? [Device], result .isEmpty == false{
                   return true
               }
           }
           catch {
               print("Device Fetch failed")
           }
          return false
       }
       

}

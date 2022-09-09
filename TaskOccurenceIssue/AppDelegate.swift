//
//  AppDelegate.swift
//  TaskOccurenceIssue
//
//  Created by Bo Zhang on 9/8/22.
//

import Foundation
import UIKit
import CareKitStore
import CareKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    let storeManager = OCKSynchronizedStoreManager(
        wrapping: OCKStore(
            name: "debug",
            type: .inMemory
        )
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Seed an all day task
        let taskStartDate = Calendar.current.startOfDay(for: Date())
        let taskEndDate = Calendar.current.date(byAdding: .day, value: 1, to: taskStartDate)
        //let taskEndDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: taskStartDate)

        let taskScheduleElement = OCKScheduleElement(
            start: taskStartDate,
            end: taskEndDate,
            interval: DateComponents(day: 1),
            text: nil,
            targetValues: [],
            duration: .allDay
        )
        let taskSchedule = OCKSchedule(composing: [taskScheduleElement])
        
        let allDayTask = OCKTask(
            id: "allDayTask",
            title: "All day task",
            carePlanUUID: nil,
            schedule: taskSchedule
        )
        
        storeManager.store.addAnyTask(allDayTask,
                                      callbackQueue: .main) { result in
            switch result {
            case let .success(task):
                print("Seed task \(task.id)")
                
            case let .failure(error):
                print("Failed to seed task: \(error as NSError)")
            }
        }
        
        
        return true
    }
}

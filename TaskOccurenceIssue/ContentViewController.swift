//
//  ContentViewController.swift
//  TaskOccurenceIssue
//
//  Created by Bo Zhang on 9/8/22.
//

import UIKit
import CareKit
import CareKitStore
import CareKitUI

class ContentViewController: OCKDailyPageViewController {
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        Task {
            let tasks = await fetchTasks(on: date)
            tasks.compactMap {
                let card = self.taskViewController(for: $0, on: date)
                return card
            }.forEach {
                listViewController.appendViewController($0, animated: false)
            }
        }
    }
    
    private func fetchTasks(on date: Date) async -> [OCKAnyTask] {
        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        
        do {
            let tasks = try await storeManager.store.fetchAnyTasks(query: query)
            return tasks
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    private func taskViewController(for task: OCKAnyTask, on date: Date) -> UIViewController? {
        switch task.id {
        case "allDayTask":
            return OCKSimpleTaskViewController(task: task, eventQuery: .init(for: date), storeManager: self.storeManager)

        default:
            return nil
        }
    }
}

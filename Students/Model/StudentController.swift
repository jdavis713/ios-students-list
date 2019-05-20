//
//  StudentController.swift
//  Students
//
//  Created by Jordan Davis on 5/20/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

class StudentController {
    
    
    
    
    
    //MARK: Persistence
    
    func loadFromPersistentStore(completion: @escaping ([Student]) -> Void) {
        //Main Queue - handles UI
        //Background Queues - everything else
        
        let bgQueue = DispatchQueue(label: "StudentQueue", attributes: .concurrent)
        
        bgQueue.async {
            let fm = FileManager.default
            
            guard let url = self.persistentFileURL,
                fm.fileExists(atPath: url.path) else {
                    completion([])
                    return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let students = try decoder.decode([Student].self, from: data)
                completion(students)
            } catch {
                NSLog("Error loading students from file: \(error)")
                completion([])
            }
        }
        
        
    }
    
    
    
    //MARK: Properties
    private var persistentFileURL: URL? {
        return Bundle.main.url(forResource: "students", withExtension: "json")
    }
    
}

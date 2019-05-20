//
//  StudentsTableViewController.swift
//  Students
//
//  Created by Jordan Davis on 5/20/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        studentController.loadFromPersistentStore { (students) in
            self.students = students
            self.editedStudents = students
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateDataSource()
            }
        }
    }

    private func updateDataSource() {
        var editedStudents: [Student]
        
        switch filterSegmentedControl.selectedSegmentIndex {
        case 1:
            editedStudents = students.filter({ (student) -> Bool in
                return student.course == "iOS"
            })
        case 2:
            editedStudents = students.filter { $0.course == "Web" }
        case 3:
            editedStudents = students.filter { $0.course == "UX" }
        
        default:
            editedStudents = students
        }
        
        if sortSegmentedControl.selectedSegmentIndex == 0 {
            editedStudents = editedStudents.sorted(by: { $0.firstName < $1.firstName })
        } else {
            editedStudents = editedStudents.sorted(by: { $0.lastName < $1.lastName })
        }
        
        self.editedStudents = editedStudents
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func sort(_ sender: Any) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: Any) {
        updateDataSource()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editedStudents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = editedStudents[indexPath.row]
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.course
        
        return cell 
    }


    //MARK: - Properties
    
    var editedStudents: [Student] = []
    var students: [Student] = []
    let studentController = StudentController()
    
    @IBOutlet var sortSegmentedControl: UISegmentedControl!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    

}

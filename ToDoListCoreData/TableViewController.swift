//
//  TableViewController.swift
//  ToDoListCoreData
//
//  Created by Kirill Drozdov on 22.11.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Tasks] = [] // main array
    
    //MARK: -  Add Task in tableView and coreData
    @IBAction func addTasks(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Новая задача", message: "Введите задачу", preferredStyle: .alert)
        
        let saveTask = UIAlertAction(title: "Сохранить", style: .default) { [self] action in  // button save
            let tf = alertController.textFields?.first
            if let newTask = tf?.text{
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField { _ in} // alert
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in} // button cancel
        
        alertController.addAction(saveTask) // add button saveTasj
        alertController.addAction(cancelAction) // add button cancelAction
        
        present(alertController, animated: true, completion: nil) // вызываем
    }

    //MARK: - Удаление
    @IBAction func deleteTasks(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context     = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            printContent(error.localizedDescription)
        }
        tableView.reloadData()
    }

    //MARK: - Save Data in CoreData
    
    func saveTask(withTitle title: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context     = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            
            try context.save() // попытка сохранения
            tasks.append(taskObject)
            
        } catch let error as NSError {
            printContent(error.localizedDescription)
        }
    }
    
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // запрос на данные
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            printContent(error.localizedDescription)
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - number Of Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - number Of Rows In Section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // MARK: - cell For Row At
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row].title
        
        return cell
    }
}

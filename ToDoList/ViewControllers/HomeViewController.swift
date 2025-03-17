//
//  ViewController.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-13.
//

import UIKit
import RealmSwift
import os

class HomeViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    let realm = try! Realm()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNotification()
        let localTasks = realm.objects(LocalTask.self)
        localTasks.forEach { localTask in
            let task = Task(id: localTask._id, category: localTask.category, caption: localTask.capion, createDate: localTask.createDate, isComplete: localTask.isComplete)
            tasks.append(task)
        }
        tableView.reloadData()
    }

    private func setupViews() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 24
        titleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(addButton)

    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(createTask(_:)), name: NSNotification.Name("com.kayo.createTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editTask(_:)), name: NSNotification.Name("com.kayo.editTask"), object: nil)

    }
    
    @objc func editTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let task = userInfo["updateTask"] as? Task else {
            return
        }
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        tasks[index] = task
        tableView.reloadData()
        
        if let localEditTask = realm.object(ofType: LocalTask.self, forPrimaryKey: task.id) {
            
            do {
                try realm.write {
                    localEditTask.capion = task.caption
                    localEditTask.category = task.category
                    localEditTask.isComplete = task.isComplete
                }
            } catch {
                let errorText = error.localizedDescription
                os_log("%@", type: .error, errorText)
            }
        }
    }
    
    @objc func createTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
        let task = userInfo["newTask"] as? Task else {
            return
        }
        tasks.append(task)
        tableView.reloadData()
        
        let localTask = LocalTask()
        localTask._id = task.id
        localTask.capion = task.caption
        localTask.createDate = task.createDate
        localTask.category = task.category
        localTask.isComplete = task.isComplete
        do {
            try realm.write {
                realm.add(localTask)
            }
        } catch {
            let errorText = error.localizedDescription
            os_log("%@", type: .error, errorText)
        }
        os_log("Task successfully created", type: .info)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaButton = view.safeAreaInsets.bottom
        let width: CGFloat = 60
        let height: CGFloat = 60
        let xPos = view.frame.width / 2 - width / 2
        let yPos = view.frame.height - height - safeAreaButton
        addButton.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        addButton.layer.cornerRadius = height / 2
    }

    @objc func addButtonTapped() {
        let newTaskViewController = NewTaskViewController()
        present(newTaskViewController, animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(withTask: tasks[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            if let taskToDelete = realm.object(ofType: LocalTask.self, forPrimaryKey: task.id) {
                do {
                    try realm.write {
                        realm.delete(taskToDelete)
                    }
                } catch {
                    let errorText = error.localizedDescription
                    os_log("%@", type: .error, errorText)
                }
            }
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension HomeViewController: TaskTableViewCellDelegate {
    func editTask(id: String) {
        guard let task = tasks.first(where: { $0.id == id }) else {
            return
        }
        let newTaskViewController = NewTaskViewController(task: task)
        present(newTaskViewController, animated: true)
    }
    
    func markTask(id: String, complete: Bool) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }
        tasks[index].isComplete = complete
        tableView.reloadData()
    }
    
    
}

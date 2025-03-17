//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-13.
//

import UIKit

protocol NewTaskDelegate: AnyObject {
    func closeView()
    func presentAlert(title: String, message: String)
}

class NewTaskViewController: UIViewController {

    lazy var modalView: NewTaskModalView = {
        let height: CGFloat = 465
        let frame = CGRect(x: 15, y: view.center.y - height / 2 , width: view.frame.width - 30, height: height)
        let modalView = NewTaskModalView(frame: frame, task: task)
        modalView.delegate = self
        return modalView
    }()
    private var task: Task?
    
    init(task: Task? = nil) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        modalView.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.addSubview(modalView)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: [.curveEaseOut]) {
            self.modalView.transform = .identity
        }
    }
    
}

//MARK: - New task view delegate methods
extension NewTaskViewController: NewTaskDelegate {

    func closeView() {
        dismiss(animated: true)
    }

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

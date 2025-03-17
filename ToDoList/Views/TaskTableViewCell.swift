//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-13.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func editTask(id: String)
    func markTask(id: String, complete: Bool)
}

class TaskTableViewCell: UITableViewCell {

    static let identifier = "TaskTableViewCell"
    
    @IBOutlet weak var categoryContainerView: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isCompleteImageView: UIImageView!
    private weak var delegate: TaskTableViewCellDelegate?
    private var task: Task!
    
    @IBOutlet weak var stripView: UIView!
    
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryContainerView.layer.cornerRadius = categoryContainerView.frame.height / 2
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }

    func configure(withTask task: Task, delegate: TaskTableViewCellDelegate) {
        categoryLabel.text = task.category.rawValue
        captionLabel.text = task.caption
        isCompleteImageView.image = task.isComplete ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        dateLabel.text = dateFormatter.string(from: task.createDate)
        selectionStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleComletion))
        isCompleteImageView.addGestureRecognizer(tap)
        isCompleteImageView.isUserInteractionEnabled = true
        categoryContainerView.backgroundColor = task.category.color.withAlphaComponent(0.15)
        categoryLabel.textColor = task.category.color
        stripView.backgroundColor = task.category.color
        self.task = task
        self.delegate = delegate
    }
    
    @objc func toggleComletion() {
        task.isComplete.toggle()
        delegate?.markTask(id: task.id, complete: task.isComplete)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editTask(id: task.id)
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

//
//  NewTaskModalView.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-13.
//

import UIKit

class NewTaskModalView: UIView {

    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    @IBOutlet private var contentView: UIView!
    weak var delegate: NewTaskDelegate?
    private var task: Task?
    
    var caption: String {
        get { descriptionTextView.text }
        set { descriptionTextView.text = newValue }
    }
    
    init(frame: CGRect, task: Task?) {
        super.init(frame: frame)
        self.task = task
        initSubview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubview()
    }
    
    func initSubview() {
        let nib = UINib(nibName: "NewTaskModalView", bundle: nil)
        nib.instantiate(withOwner: self)
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        if let task = task {
            descriptionTextView.text = task.caption
            descriptionTextView.textColor = .label
            let rowIndex = Category.allCases.firstIndex(of: task.category)!
            categoryPickerView.selectRow(rowIndex, inComponent: 0, animated: false)
        } else {
            descriptionTextView.text = "Add caption..."
            descriptionTextView.textColor = .placeholderText
            categoryPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 5

    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.closeView()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let caption = descriptionTextView.text,
              descriptionTextView.textColor != .placeholderText,
              caption.count >= 4 else {
            delegate?.presentAlert(title: "Caption Error", message: "You need to provide description 4 or more characters.")
            return
        }
        let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
        let category = Category.allCases[selectedRow]

        if let task = task {
            let task = Task(id: task.id, category: category, caption: caption, createDate: task.createDate, isComplete: task.isComplete)
            let userInfo: [String: Task] = ["updateTask": task]
            NotificationCenter.default.post(name: NSNotification.Name("com.kayo.editTask"), object: nil, userInfo: userInfo)
            
        } else {
            let task = Task(id: UUID().uuidString, category: category, caption: caption, createDate: Date(), isComplete: false)
            let userInfo: [String: Task] = ["newTask": task]
            NotificationCenter.default.post(name: NSNotification.Name("com.kayo.createTask"), object: nil, userInfo: userInfo)
        }
        delegate?.closeView()
    }
    
    
    
}

extension NewTaskModalView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add caption..."
            textView.textColor = .placeholderText
        }
    }
}

extension NewTaskModalView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
}

extension NewTaskModalView: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return Category.allCases[row].rawValue
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 16, weight: .regular)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Category.allCases[row].rawValue
        return pickerLabel!
    }
}

//
//  SettingViewController.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-14.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTitleLabel.font = UIFont.style(.subTitle)
        appThemeLabel.font = UIFont.style(.body)
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        if let window = window {
            switch window.overrideUserInterfaceStyle {
            case .light:
                segmentedControl.selectedSegmentIndex = 0
            case .dark:
                segmentedControl.selectedSegmentIndex = 1
            case .unspecified:
                segmentedControl.selectedSegmentIndex = 2
            default:
                segmentedControl.selectedSegmentIndex = 2
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        modalView.layer.cornerRadius = 5
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        if sender.selectedSegmentIndex == 0 {
            window?.overrideUserInterfaceStyle = .light
        } else if sender.selectedSegmentIndex == 1 {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
}

//
//  NewActivityViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit
import MapKit
import UserNotifications

class NewActivityViewController: UIViewController {
    weak var delegate: AddNewActivityDelegate?
    weak var coordinator: ProfileCoordinator?
    weak var coordinatorCurrent: CurrentCoordinator?
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let newActivityView = NewActivityView()
    
    lazy var userCurrency: String = {
        let userC = self.getUserCurrency()
        return userC
    }()
    
    override func loadView() {
        view = newActivityView
    }
    
    var currencyType: String = "$" {
        didSet {
            newActivityView.valueTable.reloadData()
        }
    }
    var fonts: [UIFont]! {
        didSet {
            // tableView.reloadData()
        }
    }
    var activity: Activity = Activity()
    var day = Day(isSelected: true, date: Date())
    var local: String = ""
    var address: String = ""
    var roadmap = Roadmap()
    var activityEdit = Activity()
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if edit {
            getData()
        }
        
        setupNewActivityView()
        setKeyboard()
        newActivityView.scrollView.delegate = self
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelCreation))
        cancelButton.tintColor = .accent
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let salvarButton = UIBarButtonItem(title: "Save".localized(), style: .plain, target: self, action: #selector(saveActivity))
        self.navigationItem.rightBarButtonItem = salvarButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !edit {
            self.currencyType = userCurrency
        }
    }
    
    @objc func cancelCreation() {
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
    
    @objc func saveActivity() {
        self.setData()
        var createdActivity: Activity?
        if edit {
            self.activity.id = Int(self.activityEdit.id)
            ActivityRepository.shared.updateActivity(day: self.day, oldActivity: self.activityEdit, activity: self.activity)
        } else {
            createdActivity = ActivityRepository.shared.createActivity(day: self.day, activity: self.activity, isNew: true)
        }
        self.delegate?.attTable()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
        if UserDefaults.standard.bool(forKey: "switch") == true {
            if let safeActivity = createdActivity {
                NotificationManager.shared.registerActivityNotification(createdActivity: safeActivity)

            }
        }
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        return currencySymbol ?? "S"
    }
}

// MARK: Keyboard extension
extension NewActivityViewController {
    fileprivate func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            newActivityView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        newActivityView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func dissMissKeyboard() {
        view.endEditing(true)
    }
    
    func setupTextFields(textField: UITextField) {
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                             target: self, action: #selector(doneButtonTapped))
            
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            
            textField.inputAccessoryView = toolbar
    }
    func setupTextView(textView: UITextView) {
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                             target: self, action: #selector(doneButtonTapped))
            
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            textView.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
        newActivityView.scrollView.isScrollEnabled = true

    }
}

// MARK: Extension Text Field
extension NewActivityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewActivityViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
}

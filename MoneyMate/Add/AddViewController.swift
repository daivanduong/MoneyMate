//
//  AddViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit
import CoreData
import IQKeyboardToolbarManager

class AddViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var segmentedControlView: UISegmentedControl!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var dateStackView: UIStackView!
    
    var viewModel: AddViewModelProtocol!
    
    var isFormatting = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewContent.layer.cornerRadius = 10
        viewContent.layer.masksToBounds = true
        viewModel.categories = viewModel.fetchCategories(for: .expense)
        setupAmountTextField()
        
        if viewModel.selectedCategory != nil {
            categoryButton.setTitle(viewModel.selectedCategory?.name ?? "Chọn danh mục", for: .normal)
        } else {
            categoryButton.setTitle(viewModel.categories[0].name!, for: .normal)
            viewModel.selectedCategory = viewModel.categories[0]
        }
        setupMenuCategory()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardToolbarManager.shared.isEnabled = true
    }
    
    
    func setupAmountTextField() {
        amountTextField.delegate = self
        amountTextField.keyboardType = .numberPad
        amountTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if isFormatting { return }
        isFormatting = true
        let cleanText = textField.text?
            .replacingOccurrences(of: ".", with: "")
            .trimmingCharacters(in: .whitespaces) ?? ""
        
        guard !cleanText.isEmpty else {
            textField.text = ""
            isFormatting = false
            return
        }
        let number = Double(cleanText) ?? 0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let formatted = formatter.string(from: NSNumber(value: number)) ?? ""
        textField.text = formatted
        isFormatting = false
    }
    
    
    func setupMenuCategory() {
        let categories = viewModel.categories
        let actions = categories.map { category in
            UIAction(
                title: category.name!,
                state: category.name! == viewModel.selectedCategory?.name ? .on : .off
            ) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.selectedCategory = category
                self.categoryButton.setTitle(category.name, for: .normal)
                self.setupMenuCategory()
            }
        }
        
        let menu = UIMenu(title: "Chọn danh mục", options: .displayInline, children: actions)
        categoryButton.menu = menu
        categoryButton.showsMenuAsPrimaryAction = true
    }
    
    
    @IBAction func segmentedSelect(_ sender: UISegmentedControl) {
        viewModel.updateSegmentIndex(sender.selectedSegmentIndex)
        setupMenuCategory()
        categoryButton.setTitle("\(viewModel.categories[0].name!)", for: .normal)
        viewModel.selectedCategory = viewModel.categories[0]
        setupMenuCategory()
        
    }
    
    @IBAction func selectDateAction(_ sender: UIDatePicker) {
        
        viewModel.selectedDate = sender.date
    }
    
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        if amountTextField.text?.isEmpty == false {
            let cleanText = amountTextField.text?
                .replacingOccurrences(of: ".", with: "")
                .trimmingCharacters(in: .whitespaces) ?? ""
            let amount = Double(cleanText)!
            if amount > 0 {
                let note = noteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.addNewTransaction(amount: amount, note: (note ?? ""))
            } else {
                showAlert(message: "Số tiền phải khác 0")
            }
        } else {
            showAlert(message: "Hãy nhập số tiền")
        }
        
        viewModel.onSaveSuccess = {  [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true) {
                    self?.viewModel.backToHomeScreen?()
                }
            }
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: "Thông báo",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
}



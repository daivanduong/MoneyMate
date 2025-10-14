//
//  AddViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    
    var backToHomeScreen: (() -> Void)?
    var viewModel: AddViewModelProtocol!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        setupPickerView()
        viewContent.layer.cornerRadius = 10
        viewContent.layer.masksToBounds = true
        //resetAppData()
        viewModel = AddViewModel()
        viewModel.preloadCategories()
        viewModel.categories = viewModel.fetchCategories(for: .expense)
        if !viewModel.categories.isEmpty {
                pickerView.selectRow(0, inComponent: 0, animated: false)
                viewModel.selectCategory(at: 0)
        }
        viewModel.reLoadPickerView = {
            self.pickerView.reloadAllComponents()
        }
        
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
            
    }
    
    
    @IBAction func segmentedSelect(_ sender: UISegmentedControl) {
        viewModel.updateSegmentIndex(sender.selectedSegmentIndex)
        
    }
    
    @IBAction func selectDateAction(_ sender: UIDatePicker) {
        viewModel.selectedDate = sender.date
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if amountTextField.text?.isEmpty == false {
            viewModel.addTransaction(amount:  Double(amountTextField.text!)!, note: (noteTextField.text ?? ""))
        } else {
            showAlert(message: "Hãy nhập số tiền")
        }
        
        viewModel.onSaveSuccess = {  [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true) {
                    self?.backToHomeScreen?()
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
    
    

    func resetAppData() {
        deleteAllData(entityName: "Transaction")
        deleteAllData(entityName: "Category")
        
    }
    func deleteAllData(entityName: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print(" \(entityName)")
        } catch let error {
            print(" \(entityName): \(error)")
        }
    }

}

extension AddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getNumberOfRowsInComponent()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getTitleForRow(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectCategory(at: row)
    }
    
}


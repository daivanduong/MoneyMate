//
//  ReportViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var financialView: UIView!
    
    @IBOutlet weak var totalIncomeView: UIView!
    @IBOutlet weak var totalIncomeLable: UILabel!
    
    @IBOutlet weak var totalExpensesView: UIView!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    
    @IBOutlet weak var totalMonthlyBalanceView: UIView!
    @IBOutlet weak var totalMonthlyBalanceLable: UILabel!
    
    @IBOutlet weak var savingRateView: UIView!
    @IBOutlet weak var savingRateLable: UILabel!
    
    var viewmodel: ReportViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftNavTitle("Báo cáo")
        setupFinancialView()
        viewmodel.fetchTotals(for: 10, year: 2025)
        getDataInLable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchTotals(for: 10, year: 2025)
        getDataInLable()
    }


    func setupFinancialView() {
        financialView.layer.cornerRadius = 10
        financialView.layer.masksToBounds = true
        financialView.layer.borderWidth = 1
        financialView.layer.borderColor = UIColor.systemGray6.cgColor
        
        [totalIncomeView, totalExpensesView, totalMonthlyBalanceView, savingRateView].forEach { view in
            view?.layer.cornerRadius = 5
            view?.clipsToBounds = true
            view?.backgroundColor = .clear
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.systemGray6.cgColor
        }
    }
    
    func getDataInLable() {
        totalIncomeLable.text = viewmodel.formattedIncome
        totalExpensesLabel.text = viewmodel.formattedExpense
        totalMonthlyBalanceLable.text = viewmodel.formattedBalance
        savingRateLable.text = viewmodel.formattedSavingRate
    }

}

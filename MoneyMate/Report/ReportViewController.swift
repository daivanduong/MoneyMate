//
//  ReportViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit

class ReportViewController: UIViewController {

    
    @IBOutlet weak var monthLable: UILabel!
    
    @IBOutlet weak var totalIncomeStackView: UIStackView!
    @IBOutlet weak var totalIncomeLable: UILabel!
    
    @IBOutlet weak var totalExpensesStackView: UIStackView!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    
    @IBOutlet weak var totalMonthlyBalanceStackView: UIStackView!
    @IBOutlet weak var totalMonthlyBalanceLable: UILabel!
    
    @IBOutlet weak var savingRateStackView: UIStackView!
    @IBOutlet weak var savingRateLable: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewmodel: ReportViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftNavTitle("Báo cáo")
        setupFinancialView()
        viewmodel.fetchTotals()
        setupTableView()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.currentMonth = Date()
        viewmodel.fetchTotals()
        updateUI()
    }


    func setupFinancialView() {

        [totalIncomeStackView, totalExpensesStackView, totalMonthlyBalanceStackView, savingRateStackView].forEach { view in
            view?.layer.cornerRadius = 5
            view?.clipsToBounds = true
            view?.backgroundColor = .clear
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.systemGray6.cgColor
        }
    }
    func updateUI() {
        totalIncomeLable.text = viewmodel.formattedIncome
        totalExpensesLabel.text = viewmodel.formattedExpense
        totalMonthlyBalanceLable.text = viewmodel.formattedBalance
        totalMonthlyBalanceLable.textColor = (viewmodel.balance > 0) ? .systemGreen : .red
        savingRateLable.text = viewmodel.formattedSavingRate
        savingRateLable.textColor = (viewmodel.balance > 0) ? .systemGreen : .red
        
        monthLable.text = viewmodel.updateMonthLabel()
        setupTableView()
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        let nib = UINib(nibName: "ReportViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reportViewCell")
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
    }
    
    
    
    @IBAction func previousButton(_ sender: UIButton) {
        viewmodel.moveToPreviousMonth()
        viewmodel.getDataForPreviousMonth()
        updateUI()
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        viewmodel.moveToNextMonth()
        updateUI()
        
    }
    
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.dataForMonth.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportViewCell") as! ReportViewCell
        cell.titleLable.text = viewmodel.dataForMonth[indexPath.row].title
        cell.subTitleLable.text = viewmodel.dataForMonth[indexPath.row].subTitle
        cell.descriptionLable.text = viewmodel.dataForMonth[indexPath.row].changeDescription
        cell.descriptionLable.textColor = (viewmodel.dataForMonth[indexPath.row].amountChange) >= 0 ? .systemGreen : .red
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

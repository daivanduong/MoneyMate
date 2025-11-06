//
//  ChartViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit
import DGCharts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var previousMonthButton: UIButton!
    
    @IBOutlet weak var nextMonthButton: UIButton!
    
    @IBOutlet weak var monthLable: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var viewModel: ChartViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftNavTitle("Biểu đồ")
        viewModel.loadTransactionSummary()
        loadUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.currentMonth = Date()
        viewModel.loadTransactionSummary()
        loadUI()
    }
    
    func loadUI() {
        setupPieChart()
        setupTableView()
        setDataForPieChart()
        monthLable.text = viewModel.updateMonthLabel()
        pieChartView.centerText = viewModel.pieChartViewName
    }
    

    func setupPieChart() {
        pieChartView.centerText = viewModel.pieChartViewName
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.transparentCircleColor = .clear
        pieChartView.legend.enabled = false
    }

    func setDataForPieChart() {
        let dataForExpense = viewModel.getDataForChart()
        let entries = dataForExpense.map { item in
            PieChartDataEntry(value: item.total, label: item.category)
        }

        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material() 
        set.sliceSpace = 2

        let data = PieChartData(dataSet: set)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 13, weight: .medium))

        pieChartView.data = data
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    func setupTableView(){
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "transactionTableViewCell")
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBAction func previousMonthAction(_ sender: UIButton) {
        viewModel.moveToPreviousMonth()
        loadUI()
    }
    
    
    @IBAction func nextMonthButton(_ sender: UIButton) {
        viewModel.moveToNextMonth()
        loadUI()
    }
    
    @IBAction func segmentedSelect(_ sender: UISegmentedControl) {
        viewModel.segmentIndex = sender.selectedSegmentIndex
        loadUI()
    }
    
}


extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getDataForChart().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell") as!  TransactionTableViewCell
        cell.titleLable.text = viewModel.getDataForChart()[indexPath.row].category
        cell.subTitleLable.text = viewModel.formatCurrency(viewModel.getDataForChart()[indexPath.row].total) + "đ"
        cell.amountLable.text = String(format: "%.1f", ((viewModel.getDataForChart()[indexPath.row].total)/viewModel.totalAmount)*100) + "%"
        cell.img.image = UIImage(named: viewModel.getDataForChart()[indexPath.row].icon)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
